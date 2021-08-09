# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kanrisuru::Nginx do
  it 'manages a cluster of nginx webservers' do
    cluster = Kanrisuru::Remote::Cluster.new([{
      username: 'ubuntu', host: 'ubuntu-host', keys: ['~/.ssh/id_rsa']
    }, {
      username: 'centos', host: 'centos-host', keys: ['~/.ssh/id_rsa']
    }, {
      username: 'opensuse', host: 'opensuse-host', keys: ['~/.ssh/id_rsa']
    }])

    cluster.su('root')
    expect(cluster).to respond_to(:nginx)

    cluster.nginx.install.each do |result|
      expect(result[:result]).to be_success
    end

    expect(cluster.nginx.installed?).to eq([
      { host: 'ubuntu-host', result: true },
      { host: 'centos-host', result: true },
      { host: 'opensuse-host', result: true }
    ])

    cluster.each do |host|
      expect(host.nginx.start).to be_success unless host.nginx.running?
    end

    pids = cluster.nginx.master_pid
    pids.each do |pid|
      expect(pid[:result]).to be_instance_of(Integer)
    end

    cluster.nginx.restart.each do |result|
      expect(result[:result]).to be_success
    end

    cluster.nginx.remove.each do |result|
      expect(result[:result]).to be_success
    end
  end
end
