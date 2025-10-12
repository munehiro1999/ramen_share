
puts "🌱 本番用データ作成を開始します..."

users = [
  { name: "ラーメン太郎", email: "taro@example.com" },
  { name: "麺子", email: "menko@example.com" },
  { name: "スープ次郎", email: "jiro@example.com" },
  { name: "チャーシュー姫", email: "chashu@example.com" },
  { name: "味玉王子", email: "ajitama@example.com" }
]

users.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.name = user_data[:name]
    u.password = "password"
    u.password_confirmation = "password"
  end

  # 本番環境ではアバターは作らない
  puts "👤 #{user.name} は本番環境なのでアバターなし"
end

puts "✅ ユーザー作成完了"


ramen_samples = [
  { title: "中華そば 青葉", genre: :ramen, rating: 4.5, address: "東京都中野区中野5-58-1" },
  { title: "つけ麺 道", genre: :tukemen, rating: 5.0, address: "東京都葛飾区亀有5-28-17" },
  { title: "油そば 春日亭", genre: :aburasoba, rating: 4.0, address: "東京都渋谷区道玄坂2-8-8" },
  { title: "家系ラーメン 吉村家", genre: :ramen, rating: 4.8, address: "神奈川県横浜市西区南幸2-12-6" },
  { title: "札幌味噌ラーメン 山頭火", genre: :ramen, rating: 4.2, address: "北海道札幌市中央区南1条西5-1" },
  { title: "博多豚骨 一蘭", genre: :ramen, rating: 4.7, address: "福岡県福岡市中央区天神1-1-1" },
  { title: "喜多方ラーメン坂内", genre: :ramen, rating: 4.3, address: "福島県喜多方市字細田7230" },
  { title: "つけ麺専門 六厘舎", genre: :tukemen, rating: 4.6, address: "東京都千代田区丸の内1-9-1" },
  { title: "油そば ぶぶか", genre: :aburasoba, rating: 4.1, address: "東京都世田谷区北沢2-26-21" },
  { title: "ラーメン二郎 三田本店", genre: :ramen, rating: 4.9, address: "東京都港区芝5-31-19" },
  { title: "家系ラーメン 武蔵家", genre: :ramen, rating: 4.4, address: "神奈川県川崎市川崎区駅前本町12" },
  { title: "つけ麺 大勝軒", genre: :tukemen, rating: 4.5, address: "東京都豊島区南池袋2-1-3" },
  { title: "油そば みやこ", genre: :aburasoba, rating: 3.9, address: "東京都中野区中野3-33-1" },
  { title: "札幌ラーメン けやき", genre: :ramen, rating: 4.3, address: "北海道札幌市中央区南7条西3-3" },
  { title: "ラーメン花月嵐", genre: :ramen, rating: 4.0, address: "東京都渋谷区道玄坂1-14-9" }
]

ramen_samples.each do |post_data|
  ramen_post = RamenPost.create!(
    title: post_data[:title],
    genre: post_data[:genre],
    rating: post_data[:rating],
    description: "ダミーコメント：#{post_data[:title]} の感想です。",
    address: post_data[:address],
    latitude: 35.0 + rand,
    longitude: 139.0 + rand,
    user: User.all.sample
  )

  # 投稿用画像をランダムで添付（50%確率で画像なし）
  if [true, false].sample
    image_path = Rails.root.join("app/assets/images/ramen1.png")
    if File.exist?(image_path)
      ramen_post.images.attach(io: File.open(image_path), filename: "ramen1.png")
      puts "🍜 #{post_data[:title]} に ramen1.png を添付しました"
    else
      puts "⚠️ ramen1.png が見つかりません"
    end
  else
    puts "🚫 #{post_data[:title]} は画像なし"
  end
end

puts "ラーメン投稿作成完了"

puts "いいねデータを作成します"

RamenPost.all.each do |post|
  User.all.sample(rand(1..3)).each do |user|
    unless post.likes.exists?(user: user)
      post.likes.create!(user: user)
      puts "💗 #{user.name} が #{post.title} にいいねしました。"
    end
  end
end

puts "本番用シードデータ作成完了！"
