# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
MediaServer::Application.config.secret_key_base = '7eab93ef024d52e75db77a691c5c19eeb45aca9c1c5f2c29e30acb950c4a442a8d2e0f1cd0c5ae96dedec7283ff52bfe48326436d0e16e0ca445054ade64100f'
