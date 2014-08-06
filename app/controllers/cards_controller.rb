class CardsController < ApplicationController
  def create
    @card = board.create_card(card_params)

    if @card.valid?
      card_html = render_to_string(@card)
      CardObserver.publish(:card_created, @card, card_html)
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
    @card.move_to(move_params)

    CardObserver.publish(:card_moved, @card, move_params)

    render nothing: true
  end

  def archive
    @card = board.cards.find(params[:id])
    @card.archive

    CardObserver.publish(:card_archived, @card)

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
    params.require(:card).permit(:list_id, :position).symbolize_keys
  end
end
