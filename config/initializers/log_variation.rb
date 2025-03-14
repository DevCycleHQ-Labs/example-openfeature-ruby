# Since this is used outside of a request context, we define a service user.
# This can contain properties unique to this service, and allows you to target
# services in the same way you would target app users.
$dvc_service_user = DevCycle::User.new({ user_id: 'api-servce' })
$service_user = OpenFeature::SDK::EvaluationContext.new(user_id: 'api-servce')
def log_variation (idx)
    features = DevCycleClient.all_features($dvc_service_user)
    variation_name = features.key?("hello-togglebot") ? features["hello-togglebot"]["variationName"] : "Default"

    wink = OFClient.fetch_boolean_value("togglebot-wink", false, $service_user)
    speed = OFClient.fetch_string_value("togglebot-speed", "off", $service_user)

    spin_chars = speed == 'slow' ? ['◜', '◝', '◞', '◟'] : ['◜', '◠', '◝', '◞', '◡', '◟']
    spinner = speed == 'off' ? '○' : spin_chars[idx % spin_chars.length]
    face = wink ? '(- ‿ ○)' : '(○ ‿ ○)'

    frame = "#{spinner} Serving variation: #{variation_name} #{face}"
    color = speed == 'surprise' ? 'rainbow' : 'blue'

    write_to_console frame, color

    timeout = speed == 'off' || speed == 'slow' ? 500 : 100
	sleep timeout / 1000.0

    log_variation((idx + 1) % spin_chars.length)
end

def add_color (text, color)
    colors = {
        "red" => "\033[91m",
        "green" => "\033[92m",
        "yellow" => "\033[93m",
        "blue" => "\033[94m",
        "magenta" => "\033[95m",
        "rainbow" => "\033[38;5;#{Time.now.to_i % 230}m"
    }
	end_char = "\033[0m"

	return colors.key?(color) ? colors[color] + text + end_char : text
end

def write_to_console (frame, color)
    frame = add_color(frame, color)
    $stdout.write "\x1b[K  #{frame}\r"
end

Thread.new do
    log_variation 0
end