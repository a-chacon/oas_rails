OasRails.configure do |config|
  config.source_oas_path = "lib/oas.json"
  config.info.title = 'Dummy API REST+'
  config.info.summary = 'Core endpoints of Dummy App.'
  config.info.description = <<~HEREDOC
    # Adimuntque regni fuerit

    ## Et fuissem licet in vetus hic Rhoetus

    Lorem markdownum currus praetemptanda vocato Canens Tartara. Chaonius demitteret
    quem **patulas pares decimae** refluum, honores: ullis nec in iunctas, ora
    fratri saeve, vix.

    ## Etenim habebat sinistra

    Docs: <https://a-chacon.com/oas_rails/>

    Teneri celebrant prius! Dedit non culmine, est duorum apertum dicione edere, ibi
    cetera Olenos quae: solita.

    - Boum alas malis miranti deum
    - Victricia ipse
    - Resque velle in adiere Phrygiae fortis postquam
    - Remisso agit nobis
    - Cyclopis superata ingentibus numquam Lucifero
  HEREDOC
  config.info.contact.name = 'Peter'
  config.info.contact.email = 'peter@gmail.com'
  config.info.contact.url = 'https://peter.com'
  config.servers = [{ url: 'http://localhost:3000', description: 'Local' },
                    { url: 'https://example.rb', description: 'Dev' }]
  config.tags = [{ name: "Users", description: "Manage the `amazing` Users table." }]

  config.security_schema = :bearer
  # config.security_schemas = {
  # }
  #

  # Default Errors
  # The default errors are setted only if the action allow it.
  # Example, forbidden will be setted to the endpoint requires authentication.
  # Example: not_found will be setter to the endpoint only if the operation is a show/update/destroy action.
  config.set_default_responses = true
  # config.possible_default_responses = [:not_found, :unauthorized, :forbidden]
  # config.response_body_of_default = "Hash{ message: String, errors: Array<String> }"
  config.response_body_of_unauthorized = "Hash{ message: String, error: Array<String> }"
  config.response_body_of_internal_server_error = "Hash{ error: String, traceback: String }"
end
