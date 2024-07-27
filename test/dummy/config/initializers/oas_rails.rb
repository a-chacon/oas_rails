OasRails.configure do |config|
  config.info.title = 'Dummy API REST'
  config.info.summary = 'Core endpoints of Dummy App.'
  config.info.description = <<~HEREDOC
    # Adimuntque regni fuerit

    ## Et fuissem licet in vetus hic Rhoetus

    Lorem markdownum currus praetemptanda vocato Canens Tartara. Chaonius demitteret
    quem **patulas pares decimae** refluum, honores: ullis nec in iunctas, ora
    fratri saeve, vix.

    ## Etenim habebat sinistra

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
end
