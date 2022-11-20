defmodule Blackjack.Game do
  use GenServer
  alias Blackjack.Cards, as: Cards

  # for multiple rooms, will need to have name reg be based on channel's room number.  for now this is fine
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def hit(player) do
    GenServer.call(__MODULE__, {:hit, player})
  end

  def stand(player) do
    GenServer.call(__MODULE__, {:stand, player})
  end

  def sit(player) do
    GenServer.call(__MODULE__, {:sit, player})
  end

  def leave(player) do
    GenServer.call(__MODULE__, {:leave, player})
  end

  def dealer_action() do
    GenServer.call(__MODULE__, :dealer_action)
  end

  def loop() do
    GenServer.call(__MODULE__, :loop)
  end

  def init(_) do
    Cards.start_link()
    {:ok, %{dealer: []}}
  end

  def handle_call({:hit, player}, _from, game) do
    dealt = Cards.deal(1)
    # concat card to player's hand
    {:reply, dealt, Map.update!(game, player, fn hand -> hand ++ dealt end)}
  end

  def handle_call({:stand, _player}, _from, game) do
    # may not need this
    {:reply, :ok, game}
  end

  def handle_call({:sit, player}, _from, game) do
    {:reply, :ok, Map.put(game, player, [])}
  end

  def handle_call({:leave, player}, _from, game) do
    {:reply, :ok, Map.delete(game, player)}
  end

  def handle_call(:dealer_action, _from, game) do
    # dealer hits until hand value >= 17
  end

  def start_round() do
    # remove old hands, shuffle,
    # deal 2 cards to each player
    # deal 2 cards to dealer
  end

  def hand_value(hand, dealt) do
    # if dealt is not an ace, just add the value of the card to the hand value
    # if dealt is an ace, add 11 to the hand value, unless the hand value is >= 11, then add 1

    ## keep in mind that currently 11 is jack, 12 is queen, 13 is king, but these are all worth 10
  end

  def handle_call(:loop, _from, game) do
    ## starts round, then loops through players, asking for action
    ## if player stands, move to next player
    ## if player busts, move to next player
    ## if player has 21, move to next player
    ## after all players have acted, call dealer_action
    ## determine results
    ## start new round
  end
end
