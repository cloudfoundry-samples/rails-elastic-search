contents = [
'Lorem ipsum dolor sit amet.',
'Consectetur adipisicing elit, sed do eiusmod tempor incididunt.',
'Labore et dolore magna aliqua.',
'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
'Excepteur sint occaecat cupidatat non proident.'
]

puts "Deleting all articles..."
Article.delete_all

puts "Creating articles..."
%w[ One Two Three Four Five ].each_with_index do |title, i|
  Article.create :title => title, :content => contents[i], :published_on => i.days.ago.utc
end
