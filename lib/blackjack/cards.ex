defmodule Blackjack.Cards do
  use GenServer

  # for multiple rooms, will need to have name reg be based on channel's room number.  for now this is fine
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def new() do
    GenServer.call(__MODULE__, :new)
  end

  def count() do
    GenServer.call(__MODULE__, :count)
  end

  def deal(n \\ 1) do
    GenServer.call(__MODULE__, {:deal, n})
  end

  def new_deck do
    # 1 = Ace, 11 = Jack, 12 = Queen, 13 = King
    deck =
      for suit <- [:hearts, :diamonds, :spades, :clubs],
          i <- 1..13,
          do: {i, suit}

    Enum.shuffle(deck)
  end

  def init(:ok) do
    {:ok, new_deck()}
  end

  def handle_call(:new, _from, deck) do
    {:reply, deck, new_deck()}
  end

  def handle_call(:count, _from, deck) do
    {:reply, Enum.count(deck), deck}
  end

  def handle_call({:deal, n}, _from, deck) do
    if n > Enum.count(deck) do
      {:reply, :not_enough_cards, deck}
    else
      {cards, remaining_deck} = Enum.split(deck, n)

      {:reply, cards, remaining_deck}
    end
  end
end
