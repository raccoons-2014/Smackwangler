5.times do
  TimePeriod.create(name: Faker::Lorem.word)
end

historical_figure_array = ["Abraham Lincoln", "Kanye West", "Confucius", "Socrates", "Genghis Khan", "Joan of Arc", "Julius Caesar", "Cleopatra", "Christopher Columbus", "William Shakespeare", "Princess Diana", "Venus Williams", "Stephen Hawking", "Martin Luther King", "Nelson Mandela", "Barack Obama", "Grace Hopper", "Napoleon", "Mao Tse-tung", "George Washington", "Spartacus", "Pocahantas", "Queen Elizabeth I", "Marie Curie", "Amelia Earhart", "Margaret Thatcher", "Kim Jong Il", "Joseph Stalin", "Mark Twain", "Friedrich Nietzsche"]

30.times do
  Card.create(type: "Hero", name: historical_figure_array.pop, time_period_id: rand(1..5), description: Faker::Lorem.sentence, strength: rand(1..5), intelligence: rand(1..5), charisma: rand(1..5))
end


deck1 = Deck.create(user_id: 1)
deck2 = Deck.create(user_id: 2)

Card.where(:id => 1..15).each do |hero|
	deck1.deck_card_relationships.create(card: hero)
end

Card.where(:id => 16..30).each do |hero|
	deck2.deck_card_relationships.create(card: hero)
end
