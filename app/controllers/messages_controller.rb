class MessagesController < ApplicationController
  def create
    session_user = SessionUser.find(params[:session_user_id])

    @message = Message.new(message_params.merge(
      session_user_id: session_user.id,
      room_id: session_user.room_id
    ))

    if @message.save
      render json: { message: @message, nikname: session_user.nikname }
    else
      render json: { error: "Message can`t save in DB" }
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
