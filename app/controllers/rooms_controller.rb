class RoomsController < ApplicationController
  before_action :config_opentok, only: [:create, :show]
  before_action :set_room, only: [:show, :edit, :update]

  def index
    @rooms = Room.all.order("created_at DESC")
  end

  def show
    @session_user = current_user.session(@room.id)
    @message = @session_user.messages.build

    gon.push({
      api_key:    @opentok.api_key,
      session_id: @room.session_id,
      token:      @session_user.token,
      nikname:    @session_user.nikname
    })
  end

  def new
    @room = Room.new
  end

  def create
    tok_session = @opentok.create_session(media_mode: :routed)
    @room = Room.new(room_params.merge(session_id: tok_session.session_id))

    if @room.save
      redirect_to rooms_path, notice: "New room was created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to rooms_path, notice: "Room was updated!"
    else
      render :edit
    end
  end

  private

  def config_opentok
    @opentok ||= OpenTok::OpenTok.new(Rails.application.secrets.api_key, Rails.application.secrets.api_secret)
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
