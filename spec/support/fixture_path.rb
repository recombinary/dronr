module Helpers
  module FixturePath

    def fixture_path(file_path)
      File.expand_path("../../fixtures/#{file_path}", __FILE__)
    end

  end
end
