class CardsController < ApplicationController
  def create
    @card = board.create_card(card_params)

    if @card.valid?
      card_html = render_to_string(@card)
      Pusher.trigger(
        "board_#{@card.list.board_id}",
        "new_card",
        id: @card.id, list_id: @card.list_id, html: card_html
      )
      CardMailer.new_card(@card).deliver
    else
      flash[:alert] = I18n.t("cards.create.error")
    end

    redirect_to board
  end

  def show
    @card = board.cards.find(params[:id])
  end

  def move
    @card = board.cards.find(params[:id])
    @card.move_to(move_params.symbolize_keys)

    Pusher.trigger(
      "board_#{@card.list.board_id}",
      "move_card",
      id: @card.id, list_id: @card.list_id, position: move_params.fetch(:position)
    )
    CardMailer.card_moved(@card).deliver

    render nothing: true
  end

  def archive
    @card = board.cards.find(params[:id])
    @card.archive

    Pusher.trigger(
      "board_#{@card.list.board_id}",
      "archive_card",
      id: @card.id, list_id: @card.list_id
    )

    redirect_to [@card.board, @card]
  end

  private

  def board
    @board ||= Board.find(params[:board_id])
  end

  def card_params
    params.require(:card).permit(:title)
  end

  def move_params
    params.require(:card).permit(:list_id, :position)
  end
end
