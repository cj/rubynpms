assets_path = './public/assets/assets.json'

if RACK_ENV != 'development' && File.exist?(assets_path)
  assets             = JSON.parse File.read(assets_path)
  precompiled_assets = {}

  assets['main'].each do |key, value|
    precompiled_assets[key] = value.sub('main.', '').gsub(/\.[a-z]{2,3}$/, '')
  end

  File.write("#{Dir.pwd}/public/assets/precompiled.json", precompiled_assets.to_json)
end
