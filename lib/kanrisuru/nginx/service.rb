# frozen_string_literal: true

module Kanrisuru
  module Nginx
    module Service
      extend OsPackage::Define

      os_define :linux, :start
      os_define :linux, :stop
      os_define :linux, :quit
      os_define :linux, :restart
      os_define :linux, :reload
      os_define :linux, :test

      os_define :linux, :running?
      os_define :linux, :master_process
      os_define :linux, :master_pid
      os_define :linux, :worker_processess

      def start(opts = {})
        command = Kanrisuru::Command.new('nginx')
        command.append_arg('-c', opts[:config])

        @host.execute_shell(command)

        Kanrisuru::Result.new(command)
      end

      def test(opts = {})
        command = Kanrisuru::Command.new('nginx')
        command.append_arg('-c', opts[:config])
        command.append_flag('-t')

        @host.execute_shell(command)

        Kanrisuru::Result.new(command)
      end

      def stop
        command = Kanrisuru::Command.new('nginx')
        command.append_arg('-s', 'stop')

        @host.execute_shell(command)

        Kanrisuru::Result.new(command)
      end

      def restart(opts = {})
        return false unless running?

        result = stop
        return false unless result.success?

        start(opts)
      end

      def reload(opts = {})
        command = Kanrisuru::Command.new('nginx')
        command.append_arg('-c', opts[:config])
        command.append_arg('-s', 'reload')

        @host.execute_shell(command)

        Kanrisuru::Result.new(command)
      end

      def running?
        process = master_process
        return false if !process || process.instance_of?(Kanrisuru::Result)

        process.respond_to?(:pid) &&
          process.pid >= 0
      end

      def master_process
        result = @host.ps
        return result if result.failure?

        result.find { |process| process.command.include?('nginx: master') }
      end

      def master_pid
        process = master_process
        return unless process.instance_of?(Kanrisuru::Core::System::ProcessInfo)

        process.pid
      end

      def worker_processess
        result = @host.ps
        return result if result.failure?

        result.select { |process| process.command.include?('nginx: worker') }
      end
    end
  end
end
