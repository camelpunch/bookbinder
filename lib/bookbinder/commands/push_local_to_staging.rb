require_relative '../distributor'
require_relative 'bookbinder_command'
require_relative 'naming'

module Bookbinder
  module Commands
    class PushLocalToStaging < BookbinderCommand
      include Commands::Naming

      def usage
        [command_name,
         "Push the contents of final_app to the staging host specified in credentials.yml"]
      end

      def run(_)
        Distributor.build(@logger, options).distribute
        0
      end

      private

      def options
        {
            app_dir: './final_app',
            build_number: ENV['BUILD_NUMBER'],

            aws_credentials: config.aws_credentials,
            cf_credentials: config.cf_staging_credentials,

            book_repo: config.book_repo,
        }
      end
    end
  end
end
