# frozen_string_literal: true

class WebpackerUploader::Manifest
  attr_reader :assets

  def initialize
    @assets = load
  end

  private

    def load
      if WebpackerUploader.config.public_manifest_path.exist?
        JSON.parse(WebpackerUploader.config.public_manifest_path.read).except("entrypoints")
      else
        {}
      end
    end
end
