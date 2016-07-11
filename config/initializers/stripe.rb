Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
  #:publishable_key => 'pk_test_XHROH7WdmuMb2WiY53BVo4nG',
  #:secret_key      => 'sk_test_4Kp8BQIX57O9gzXHcGw6rOi1'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
