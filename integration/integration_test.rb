# frozen_string_literal: true

require "test_helper"

class IntegrationTest < Minitest::Test
  def client
    @@client ||= localstack_client
  end

  def setup
    Rails.application.load_tasks
    client.create_bucket(bucket: "assets")
  end

  def teardown
    client
      .list_objects_v2(bucket: "assets")
      .contents
      .each { |o| client.delete_object(bucket: "assets", key: o.key) }

    client.delete_bucket(bucket: "assets")
  end

  def test_upload
    out, err = capture_subprocess_io do
      Rake.application["assets:upload"].invoke()
    end

    assert_empty err

    assert_match(/Processing \/[\w\/]*public\/packs\/css\/application-865c35c1\.css as text\/css/, out)
    assert_match(/Processing \/[\w\/]*public\/packs\/js\/application-e05d03f5445476a05b88\.js as application\/javascript/, out)
    assert_match(/Skipping \/[\w\/]*public\/packs\/js\/application-e05d03f5445476a05b88\.js\.map/, out)
    assert_match(/Processing \/[\w\/]*public\/packs\/media\/images\/1x1-ffffffff-4407fc94659d2c98f72b52547e94cd02\.jpg as image\/jpeg/, out)
    assert_match(/Processing \/[\w\/]*public\/packs\/media\/images\/1x1-ffffffff-d8d9b1fbe898b2cdc8a5a00623a93666\.png as image\/png/, out)
    assert_match(/Processing \/[\w\/]*public\/packs\/media\/images\/1x1-ffffffff-24abf1225f6b57ef3ab37f5b2822b6a2\.webp as image\/webp/, out)
  end
end
