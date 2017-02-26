class SessionUsersController < ApplicationController
  before_action :set_opentok, only: [:create, :update]
  before_action :set_room, only: [:new, :create]
  before_action :set_session_user, only: [:update, :edit]

  def new
    @session_user = SessionUser.new
  end

  def create
    token = @opentok.generate_token(@room.session_id, { role: session_user_params[:role].to_sym } )

    @session_user = SessionUser.new(session_user_params.merge({
      token: token,
      room_id: @room.id,
      user_id: current_user.id
    }))

    if @session_user.save
      redirect_to @room
    else
      render :new
    end
  end

  def edit
    @room = @session_user.room
  end

  def update
    @room = @session_user.room

    token = @opentok.generate_token(@room.session_id, { role: session_user_params[:role].to_sym } )

    if @session_user.update(session_user_params.merge({ token: token }))
      redirect_to @room
    else
      render :edit
    end
  end

  private

  def session_user_params
    params.require(:session_user).permit(:role, :nikname)
  end

  def set_opentok
    @opentok = OpenTok::OpenTok.new(Rails.application.secrets.api_key, Rails.application.secrets.api_secret)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_session_user
    @session_user = SessionUser.find(params[:id])
  end
end
