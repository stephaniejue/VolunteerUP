# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# To create all Users
user_names = ["Ally", "Barney", "Carson", "Dierdre", "Esther", "Fox", "Gary",
              "Hannibal", "Ingrid", "Julius", "Kendra", "Lily", "Marshall",
              "Newton", "Odell", "Pierce", "Queen", "Robin", "Sia", "Ted",
              "Utah", "Vinnie", "Washington", "Xanthipe", "Yosh", "Zeke"]
password = "123456"
city = ["Carlsbad", "Chula Vista", "Coronado", "Del Mar", "El Cajon", "Enciniatas",
        "Escondido", "Imperial Beach", "La Mesa", "Lemon Grove", "National City",
        "Oceanside", "Poway", "San Diego", "San Marcos", "Santee", "Solana Beach",
        "Vista"]
state = "CA"

user_names.each do |user|
  User.create!(email: user[0] + "@yahoo.com", name: user, password: password,
    city: city[rand(17)], state: state)
end


# To create all Organizations
org_names = ["We Help", "Food Bankers", "Red Cross", "Real Helpers",
  "Salvation Army"]
descriptions = ["We help people.", "Animals are our priority.", "Don't run away",
  "We are serious organization!", "Just like your next door neighbor."]

org_names.each_with_index do |org, index|
  phone = "(#{rand(10).to_s * 3})#{rand(10).to_s * 3}-#{rand(10).to_s * 4}"
  Organization.create!(name: org, description: descriptions[index],
    phone: phone, email: "#{org.split(" ").join("")}@yahoo.com",
    website: "www.#{org.split(" ").join("")}.org")
end

# To create all Events
event_locations = [
  {"Carlsbad" => { street: "2924 Carlsbad Blvd", postal_code: "92008" }},
  {"Chula Visat" => { street: "2127 Olympic Parkway", postal_code: "91915" }},
  {"Coronado" => { street: "960 Orange Ave", postal_code: "92118" }},
  {"Del Mar" => { street: "1435 Camino Del Mar", postal_code: "92014" }},
  {"El Cajon" => { street: "1591 Magnolia Ave", postal_code: "92020" }},
  {"Encinitas" => { street: "453 Sante Fe Dr", postal_code: "92024" }},
  {"Escondido" => { street: "320 W Valley Pkwy", postal_code: "92025" }},
  {"Imperial Beach" => { street: "700 13th St", postal_code: "91932" }},
  {"La Mesa" => { street: "8138 La Mesa Blvd", postal_code: "91942" }},
  {"Lemon Grove" => { street: "3521 Lemon Grove Ave", postal_code: "91945" }},
  {"National City" => { street: "1401 E Plaze Blvd", postal_code: "91950" }},
  {"Oceanside" => { street: "1779 Oceanside Blbd", postal_code: "92054" }},
  {"Poway" => { street: "12202 Poway Rd", postal_code: "92064" }},
  {"San Diego" => { street: "1011 Market St", postal_code: "92101" }},
  {"San Marcos" => { street: "126 Knoll Rd", postal_code: "92069" }},
  {"Santee" => { street: "9161 Mission Gorge Rd", postal_code: "92071" }},
  {"Solana Beach" => { street: "125 Lomas  Santa Fe Dr", postal_code: "92075" }},
  {"Vista" => { street: "170 Emerald Dr", postal_code: "92083" }}
]
causes = ["For the children", "For the animals", "For the environment",
  "For the poor", "For the schools", "For the disaster victims", "For the hungry"]
event_names = [
  { "Blood Drive" => { description: "Give blood", cause: causes[rand(causes.length)] }},
  { "Toy Drive" => { description: "Give toys", cause: causes[rand(causes.length)] }},
  { "Canned Goods Drive" => { description: "Give Canned Goods", cause: causes[rand(causes.length)] }},
  { "Clothes Drive" => { description: "Give Clothes", cause: causes[rand(causes.length)] }},
  { "Pick Up Waste" => { description: "Pick up trash", cause: causes[rand(causes.length)] }}
]

15.times do |iter|
  names_index = rand(event_names.length)
  name_key = event_names[names_index].keys[0]
  causes_index = rand(causes.length)
  loc_index = rand(event_locations.length)
  loc_key = event_locations[loc_index].keys[0]
  s = DateTime.now + rand(14)
  e = s + ((rand(24) + 1) / 24.0)

  Event.create!(name: name_key,
    description: event_names[names_index][name_key][:description],
    cause: causes[causes_index], start_time: s, end_time: e,
    street: event_locations[loc_index][loc_key][:street],
    city: loc_key, state: "CA",
    postal_code: event_locations[loc_index][loc_key][:postal_code], country: "USA",
    volunteers_needed: rand(20) + 1, organization: Organization.order("RANDOM()").first)
end
