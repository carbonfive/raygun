module Raygun
  class TemplateRepo
    attr_reader :name, :branch, :tarball, :sha

    def initialize(repo)
      @name, @branch = repo.split('#').map(&:strip)
      fetch
    end

    private

    def fetch
      return if @branch && @sha
      @branch ? fetch_branches : fetch_tags
    end

    def handle_github_error(response)
      puts  ""
      print "Whoops - need to try again!".colorize(:red)
      puts  ""
      print "We could not find (".colorize(:light_red)
      print "#{name}".colorize(:white)
      print "##{branch}".colorize(:white) if @branch
      print ") on github.".colorize(:light_red)
      puts  ""
      print "The response from github was a (".colorize(:light_red)
      print "#{response.code}".colorize(:white)
      puts  ") which I'm sure you can fix right up!".colorize(:light_red)
      puts  ""
      exit 1
    end

    def handle_missing_tag_error
      puts  ""
      print "Whoops - need to try again!".colorize(:red)
      puts  ""
      print "We could not find any tags in the repo (".colorize(:light_red)
      print "#{name}".colorize(:white)
      print ") on github.".colorize(:light_red)
      puts  ""
      print "Raygun uses the 'largest' tag in a repository, where tags are sorted alphanumerically.".colorize(:light_red)
      puts  ""
      print "E.g., tag 'v.0.10.0' > 'v.0.9.9' and 'x' > 'a'.".colorize(:light_red)
      print ""
      puts  ""
      exit 1
    end

    def fetch_branches
      response = http_get("https://api.github.com/repos/#{name}/branches/#{branch}")
      handle_github_error(response) unless response.code == "200"
      result = JSON.parse(response.body)
      @sha = result['commit']['sha']
      @tarball = result['_links']['html'].gsub(%r(/tree/#{branch}), "/archive/#{branch}.tar.gz")
    end

    def fetch_tags
      response = http_get("https://api.github.com/repos/#{name}/tags")
      handle_github_error(response) unless response.code == "200"

      result = JSON.parse(response.body).first
      handle_missing_tag_error unless result
      @sha = result['commit']['sha']
      @tarball = result['tarball_url']
    end

    def http_get(url)
      uri          = URI(url)
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request      = Net::HTTP::Get.new(uri)

      http.request(request)
    end
  end
end
