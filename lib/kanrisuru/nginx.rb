# frozen_string_literal: true

require_relative 'nginx/version'
require_relative 'nginx/signal'
require_relative 'nginx/package'
require_relative 'nginx/service'

module Kanrisuru
  module Nginx
  end

  module Remote
    class Host
      os_include Kanrisuru::Nginx::Package, namespace: :nginx
      os_include Kanrisuru::Nginx::Service, namespace: :nginx
    end

    class Cluster
      os_collection Kanrisuru::Nginx::Package, namespace: :nginx
      os_collection Kanrisuru::Nginx::Service, namespace: :nginx
    end
  end
end
