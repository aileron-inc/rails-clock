# frozen_string_literal: true

require_relative "lib/rails/clock"

# 基本的な使用例
puts "Current reference time: #{Rails::Clock.reference_time}"

# 時刻を設定
Rails::Clock.reference_time = Time.new(2024, 1, 1, 12, 0, 0)
puts "Set reference time: #{Rails::Clock.reference_time}"

# withブロックで一時的に変更
Rails::Clock.with(Time.new(2024, 12, 25, 0, 0, 0)) do
  puts "Christmas time: #{Rails::Clock.reference_time}"
end
puts "Back to original: #{Rails::Clock.reference_time}"

# コントローラーでの使用例（擬似コード）
class ExampleController
  include Rails::Clock::ControllerSupport

  def show
    # requested_at メソッドが使える
    puts "Request time: #{requested_at}"
  end
end

# モデルでの使用例（擬似コード）
class ExampleModel
  include Rails::Clock::ModelSupport

  def expired?
    expires_at < reference_time
  end
end
