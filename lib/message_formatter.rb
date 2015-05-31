require 'multi_json'
require 'googl'

$config = YAML.load_file(File.join('config', 'config.yml'))

class MessageFormatter
  def self.messages(json)
    msgs = []
    info = MultiJson.load(json)
    branch = info['ref'].split('/').last
    info['commits'].each do |ci|
      url = self.short_url(ci['url'])
      ci_title = ci['message'].lines.first.chomp
      msg = "[#{info['repository']['name'].capitalize}(#{branch})] #{ci['author']['name']} | #{ci_title} | #{url}"
      msgs << msg
    end
    return msgs
  end

  def self.short_url(url)
	if($config['google_api_key'])
    		Googl.shorten(url,nil, $config['google_api_key']).short_url
	else
		url
	end
  end
end
