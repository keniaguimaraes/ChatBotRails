class CallbackController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    if params["hub.verify_token"] == "asd"
      render json: params["hub.challenge"]
    end
  end

def recieved_data
    therequest = request.body.read
    data = JSON.parse(therequest)
    parse_data(data)
    render "recieved_data"
  end

  def parse_data(data)
    enteries = data["entry"]
    enteries.each do |entry|
      entry["messaging"].each do |messaging|
        sender = messaging["sender"]["id"]
        text = messaging["message"]["text"]
        analysis(sender, text.downcase)
      end
    end
  end

  def analysis(sender, text)
    message = Message.where(:recieved => text).first
    if message
      reply = message.reply
    else
      reply = "Sorry not found"
    end
    send_message(sender,reply)
  end

  def send_message(sender, text)
    myjson = {"recipient": {"id": "#{sender}"},"message": {"text": "#{text}"}}
    puts HTTP.post(url, json: myjson)
  end
  
  def url
    "https://graph.facebook.com/v2.6/me/messages?access_token=EAAC63EE7qNABAAVuoFcHvFEDeMHxbTC2Xf0NfZAf2WhX65Lmn9ErHWXNCrvEEiZB6dZAhpuZCK0kPDXHz7Ra0va7LITfMrmRa0VZB2THzVLt5ZAZAYO8f0mTGKs2gjcrRh5A2wfYsISIdgFZAHpyrIRUMoeN29lxgMMdlcSfahZALQbCtb0wLJxEL"
  end 
 
end
