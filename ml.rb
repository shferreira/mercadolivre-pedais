#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'json'
require 'rest_client'
require 'ostruct'

$blacklist = [ 'board', 'fonte', 'pedaleira', 'controlador', 'fonte', '-cabo-', '-foot', 'sustain', 'metal', 'defeito', 'frete-gratis-pronta-entrega', 'frete-gratis-e-pronta-entrega', '-case-', '-chines-', '-chins-', '-copia-', 'supply', '-handmade-', '-analogo-ao-', 'similar', 'replica', 'clone', 'sardinha', 'valvula', 'express', 'bumbo', 'zoom', 'marshall', 'fender', '-yamaha-', 'danelectro', '-fire-', 'nux', 'joyo', 'mooer', 'landscape', 'meteoro', 'waldman', 'onerr', 'rocktron', 'randall', 'hotone', 'morley', 'modtone', 'nobels', 'line-6', 'vox', '-tech-21-', '-gig-fx-', 'furma', 'mann-', 'furhman', '-andy-', '-gian', '-nig-', '-beh', 'black-sn', 'br-tech', '-grit', 'crafter', 'cruzer', 'marca-chorus', 'oliver', 'arion', 'greatone', 'mfio', 'roxy', 'black-bug', 'axces', 'groovin', 'santo-angelo', 'killer', 'xvive', 'aroma', 'toms-line', 'tomsline', 'audiobox', '-amw-', 'washburn', '-arcano-', '-e-wave-', 'caline', 'shelter', '-berin', 'victoria', 'mirand', 'byiang', 'eds-mod', 'samtone', 'mogoo', 'rocktek', '-eno-', 'soundtank', 'borne', 'wavebox', 'rogue', 'artec', 'deltalab', 'biyang', '-efx-', 'keffect', 'kft', 'bad-dog', 'rhino', 'zapata', 'stardust', 'uchoa', '-jl-', '-jld-', 'akai', 'monstro', 'mg-music', 'udo-fuzz', 'old-fuzz', '-eng-', 'clark', 'berro', 'mr-rock', '-edy-', '-alien-', '-simulamp-', '-little-bear-', '-donner-', '-empower-', '-donner-', '-darta-', '-crank-', '-moogo-', '-spanish-guitar-', '-onner-', '-ultratone-', '-groove-', '-cacau-', '-voxman-', '-vox-man-', '-danamp-', '-pedrone-', 'garage-tone', 'oneal', 'alphaverb', 'collateral', '-rmv-', '-reaction-', '-movall-', '-muza-', '-medeli-', '-daphon-', '-chill-switch-', '-cfd-', 'crybaby', 'volume', 'v-845', 'hot-head', 'ds7', 'sh7', 'sm7', 'fz7', 'fl5', 'mxr-dist', 'phase-90', 'phaser-90', 'dyna-comp', 'dynacomp', 'wah', 'wha', 'cry-baby', 'crybaby', 'crunchtone', 'bass-chorus', 'equaliz', 'noise', 'simulator', 'v-amp', 'pandora', 'bad-monkey', 'roadkill', '-gdi-', '-bdi-', '-pod-', '-jd9-', '-bb9-', '-istomp-', '-grunge-', '-the-mole-', '-jet-drive-', '-sansamp-', '-dark-matter-', '-mojo-mojo-', 'ds1', 'ds-1', 'ds2', 'ds-2', 'sd-1', 'sd1', 'os-2', 'os2', 'cs3', 'cs-3', 'ce-5', 'ce5', 'ch1', 'ch1', 'bf-2', 'bf2', 'bf-3', 'bf3', 'hr-2', 'hr2', 'turbo-dist', 'super-over', 'mega-dist', 'dyna-drive', 'combo-drive', 'super-chorus', 'boss-overdrive', 'hot-rod', 'palmer', 'bag-pedal', '-rack-', 'option-5', 'ec-pedals', 'fuzz-unit', 'pedal-board', 'top-tone', 'ch-1', 'ch1', 'od3', 'od-3', 'star-dust', 'dedalo', 'fv-500', 'ph3', 'ph-3', 'dark-meter', 'super-charged', 'fz-5', 'fz5', 'lexsen', '-aura-', '-bag-', 'odb-3', 'odb3', 'amplificador', 'tap-tempo', '-aria-', 'od-2', '-cabos-', '-element-', 'ab-y', 'ls-2', 'mod-tone', '-tama-', 'empower', 'loop-master', 'pedal-punch', 'polytune-clip', 'varranger', '-di-giorgio-', 'garagetone', 'vintage-tube-over', 'ab-2', 'fuhrm', 'rv-70', 'fv-50l', '-gn-', 'irig', 'grelha', 'easy-drive', 'mostone', 'furh', 'estojo', 'palheta', 'dinosaur', 'killswitch', 'pw-2', 'multi-fx', 'strinberg', 'ab-box', 'md2', 'md-2', 'jet-city', 'lmb-3', 'moksy', 'moer', 'ab2', 'casio', 'wild-overdrive', 'pacote', '-power-bridge-', 'fhur', 'hardcase', 'cool-cat', '-arc-dd-', 'time-machine', 'deviser', 'knockout', 'dp-10', 'tecsener', 'metrnomo', 'metronomo', 'capotraste', 'moodtone', 'ultra-di', '-cola-', '-field-booster-', 'bateria-elet', 'rockbag', 'fs5u', 'v-tone', 'super-rat', 'on-stage', 'churus', '-snake-', 'rocktuner', 'radio-amador', 'dd-400', 'guitarra-trigger', 'connarus', 'mixing-boost', 'brutal-distortion', 'furm', 'rockson', 'captadores', 'dp-2', 'dp2', 'para-bateria', 'landscap', 'da-crystal', 'hobbert', 'freio', 'microverb', 'nanoverb', 'dp10', 'muff-over', 'double-muff', 'lumberjack', 'white-green', 'bod-100', '-supra-', 'tu-10', '-chaves-', 'one-spot', '1-spot', 'hand-made', 'tarracha', 'newell', 'speaker-cable', 'applause', 'loopgang', 'mt2', 'mt-2', '-wg-', 'tom-tone', 'tektube', 'tekover', 'tekdrive', 'tomtone', 'fs-6', 'h9-control', 'amplee', '-hbr-', 'dn-2', 'madlab', 'trinity-ex', 'pedal-feito', 'mr-boogie', 'the-compressor', 'blackstar', 'myomorpha', '-dmt-', 'signal-pad', 'xt-2', 'mc-systems', '-mole-', '-jackhammer-', 'm104', 'm-104', 'boss', 'tc-ele', 'tone-freak', 'micro-amp', 'black-label', '-gni-', 'v-guitar', 'jimi-hendrix-system', 'kronos', 'bass-od', '-zakk-', 'pitchblack', '-buffalo-', '-fredric-', 'jet-drive', 'bottom-boost', 'octave-multiplex', 'radded-pick', 'time-core', 'mod-core', 'simulador', 'vitoo', '-gfs-', 'vamp', '-romani-', '-rhs-', '-gf-', '-overtone-', '-china-', '-green-mile-', 'tonebug', '-drj-', '-problema-', 'digitech-rp', 'pt-21', 'tweak-fuzz', 'power-grid', '-puma-', 'planet-waves', '-jk-', 'phone-amplifier', 'tu-300', 'power-click', 'ps-1', 'cruztools', 'stomp-audio', 'dod-fx', 'white-and-green', 'bffx', 'hofner', 'angel-chours', 'caser', '-shot-', 'hellbaby', 'oldtronics', 'multi-chorus', '-alber-', 'tekdelay', 'smash-box', 'marshall', 'sanpera', 'peavey', 'pedrone', 'penta-switch', 'gibson-maestro', 'cignus', 'soul-preacher', 'lpb1', 'lpb-1', '-jcs-', 'felipe-andreoli', 'shred-pro', '-custom-badass-', 'decimator', 'strobo-stomp', 'strobostomp', 'multi-efeito', 'kit-com-', 'stomp-box-fsa', 'microamp', 'revolution-tube', 'esi-audio', 'korg-dt', 'doctorzen', 'semicase', 'crazy-cacti', 'mosky', 'pedaleiro', 'mg-muff', 'doctor-drive', 'crunsh', 'amt-legend', 'bherin', 'delta-lab', 'strum-tuner', 'digitech-bp', 'maxon', 't-rex', 'muff-germanium', 'pi-germanium', 'zakk-wylde', 'zack-w', 'master-bass-drive', 'sparkle-drive', 'pedal-control', 'prime-distortion', 'distortion-iii', 'mxr-jimi-hendrix', '-amt-', 'austin', 'soul-food', 'processador', 'smartyn', 'studio-v3', 'compressor', 'freq-boost', '-bbe-', 'malekko', 'mr-black', '-demon-d-', '-dod-', '-gate-', '-comp-', 'session-man', '-capo-', '-morpheus-', 'new-yin-yang', 'dimarzio', 'road-rage', 'black-box', '-kent-', 'blood-drive', 'x-treme', 'wasabi', 'solid-gold', 'gi-guitar', '-gta', 'brutal-dist', 'brtech', 'snark', 'demon-tube', 'wylde', 'frist-act', 'lanscape', 'alesis', 'us-dream', 'harley', 'beggiato', 'breaker', 'jet-city', 'bass-ball', 'tone-factor', 'favoretti', 'majesty', 'moen', 'dr-j', '-cable-', 'first-act', 'hell-bab', 'rowin', 'captador', 'i-rig', 'tagima', '-ts5-', 'joy-fx', 'stevaudio', 'rocktron', 'screaming-bird', 'mighty', 'sollo', 'velouria', 'wingerter' ]
$sellers = [ 25787930, 84035678, 87667099, 143097734, 6151435, 74020612, 176509640, 77693151, 79517718, 178539042, 145971434, 30627994, 114744870, 179385353, 75822447 ]
$BASE_URL = "https://api.mercadolibre.com/sites/MLB/search?category=MLB3007&condition=used&sort=price_desc&price=100-400"

get '/' do
  page = params[:page].to_i || 0
  json = RestClient.get("#{ $BASE_URL }&offset=#{ page * 50 }")
  data = JSON.parse(json)["results"]
  all = data.map { |e| OpenStruct.new(link: e["permalink"], image: e["thumbnail"], title: e["title"], price: e["price"], seller: e["seller"]["id"]) }
  results = all.select { |e| !($blacklist.any? { |b| e.link.include?(b) } || $sellers.include?(e.seller)) }

  @r = OpenStruct.new(r: results, page: page + 1)
  erb :index
end

__END__

@@layout
<!DOCTYPE html>
<html>
  <head>
    <title>Mercado Livre</title>
    <style>
      body { font-family: Helvetica, Arial, sans-serif; }
      article { float: left; width: 180px; height: 250px; border: 1px solid #ddd; box-shadow: 0 3px 4px #ccc; margin: 10px; padding: 10px; }
      article img { display: block; margin: 0px auto; max-width: 100%; max-height: 100%; width: 100px; height: 100px;}
      article nav { font-size: 100px; text-align: center; color: #ddd; }
      article .desc { font-size: 14px; line-height: 18px; margin: 0 0 10px; }
      article .price { color: #900; font-size: 16px; font-weight: bold; }
    </style>
  </head>
  <body>
    <%= yield %>
  </body>
</html>

@@index
<% @r.r.each do |result| %>
  <article>
    <a href="<%= result.link %>">
      <img src="<%= result.image %>" alt="<%= result.title %>">
      <div class="desc"><%= result.title %></div>
    </a>
    <div class="price">R$ <%= result.price %></div>
    <small><%= result.seller %></small>
  </article>
<% end %>
<a href="/?page=<%= @r.page %>">
  <article>
    <nav>+</nav>
  </article>
</a>
