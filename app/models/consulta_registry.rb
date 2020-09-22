class ConsultaRegistry extend ActiveSupport::PerThreadRegistry

  def self.push
    $calling_counter += 1
  end

  def self.count
    $calling_counter
  end

end

$calling_counter = 0