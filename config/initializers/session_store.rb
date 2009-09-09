# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_enrolment_states_session',
  :secret      => '368e0630206a2fed567584c2795dbe24dfd143cc349c1f9e6bd91152be06ba03562a9a62663990aa5bb72b23608c0556e9a0d9864c74e002a13e6522d4d67be6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
