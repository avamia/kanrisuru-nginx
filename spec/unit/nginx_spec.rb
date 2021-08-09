# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kanrisuru::Nginx do
  it 'responds to fields' do
    expect(Kanrisuru::Nginx::Signal::SIGHUP).to eq('reload')
    expect(Kanrisuru::Nginx::Signal::SIGQUIT).to eq('quit')
    expect(Kanrisuru::Nginx::Signal::SIGTERM).to eq('stop')
    expect(Kanrisuru::Nginx::Signal::SIGUSR1).to eq('reopen')
    expect(Kanrisuru::Nginx::Signal::SIGUSR2).to eq('upgrade')
  end
end
