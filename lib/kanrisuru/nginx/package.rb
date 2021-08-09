# frozen_string_literal: true

module Kanrisuru
  module Nginx
    module Package
      extend OsPackage::Define

      os_define :linux, :version

      os_define :debian, :apt_installed?,    alias: :installed?
      os_define :fedora, :yum_installed?,    alias: :installed?
      os_define :sles,   :zypper_installed?, alias: :installed?

      os_define :debian, :apt_install,    alias: :install
      os_define :fedora, :yum_install,    alias: :install
      os_define :sles,   :zypper_install, alias: :install

      os_define :debian, :apt_update,    alias: :update
      os_define :fedora, :yum_update,    alias: :update
      os_define :sles,   :zypper_update, alias: :update

      os_define :debian, :apt_remove,    alias: :remove
      os_define :fedora, :yum_remove,    alias: :remove
      os_define :sles,   :zypper_remove, alias: :remove

      def apt_installed?
        result = @host.apt('list', installed: true, packages: ['nginx'])
        return false if result.failure?

        package = result.find { |item| item.package == 'nginx' }
        Kanrisuru::Util.present?(package) && package.installed == true
      end

      def yum_installed?
        result = @host.yum('list', installed: true, query: 'nginx')
        return false if result.failure?

        package = result.find { |item| item.package == 'nginx' }
        Kanrisuru::Util.present?(package)
      end

      def zypper_installed?
        result = @host.zypper('info', packages: ['nginx'])
        return false if result.failure?

        package = result.find { |item| item.package == 'nginx' }
        Kanrisuru::Util.present?(package) && package.installed == true
      end

      def version
        command = Kanrisuru::Command.new('nginx -v')

        @host.execute_shell(command)

        Kanrisuru::Result.new(command) do |cmd|
          values = cmd.to_s.split('/')
          values[1].to_f
        end
      end

      def apt_install
        @host.apt('install', packages: ['nginx'])
      end

      def yum_install
        @host.yum('install', packages: ['nginx'])
      end

      def zypper_install
        @host.zypper('install', packages: ['nginx'])
      end

      def apt_update
        @host.apt('update')
      end

      def yum_update
        @host.yum('update')
      end

      def zypper_update
        @host.zypper('update')
      end

      def apt_remove
        if @host.nginx.running?
          result = @host.nginx.stop
          return result unless result.success?
        end

        @host.apt('purge', packages: %w[nginx nginx-common])
      end

      def yum_remove
        if @host.nginx.running?
          result = @host.nginx.stop
          return result unless result.success?
        end

        @host.yum('remove', packages: ['nginx'])
      end

      def zypper_remove
        if @host.nginx.running?
          result = @host.nginx.stop
          return result unless result.success?
        end

        @host.zypper('remove', packages: ['nginx'])
      end
    end
  end
end
