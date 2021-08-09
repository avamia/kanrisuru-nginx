# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kanrisuru::Nginx do
  TestHosts.each_os do |os_name|
    context "with #{os_name}" do
      let(:host_json) { TestHosts.host(os_name) }
      let(:host) do
        Kanrisuru::Remote::Host.new(
          host: host_json['hostname'],
          username: host_json['username'],
          keys: [host_json['ssh_key']]
        )
      end

      after do
        host.disconnect
      end

      it 'manages the nginx package' do
        host.su('root')

        expect(host.nginx).not_to be_installed
        expect(host.nginx.install).to be_success
        expect(host.nginx).to be_installed

        expect(host.nginx.start).to be_success unless host.nginx.running?

        expect(host.nginx).to be_running
        expect(host.nginx.master_process).to be_instance_of(Kanrisuru::Core::System::ProcessInfo)

        pid_start = host.nginx.master_pid
        expect(pid_start).to be_instance_of(Integer)

        expect(host.nginx.restart).to be_success
        pid_end = host.nginx.master_pid
        expect(pid_end).not_to eq(pid_start)

        workers = host.nginx.worker_processess
        expect(workers).to be_instance_of(Array)
        expect(workers[0]).to be_instance_of(Kanrisuru::Core::System::ProcessInfo)
        expect(workers[0].ppid).to eq(pid_end)

        expect(host.nginx.stop).to be_success if host.nginx.running?
        expect(host.nginx.remove).to be_success
        expect(host.nginx).not_to be_installed
      end

    end
  end
end
{}