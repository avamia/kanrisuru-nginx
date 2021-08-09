# frozen_string_literal: true

module Kanrisuru
  module Nginx
    module Signal
      SIGHUP = 'reload'
      SIGQUIT = 'quit'
      SIGTERM = 'stop'
      SIGUSR1 = 'reopen'
      SIGUSR2 = 'upgrade'
    end
  end
end
