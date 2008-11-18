include QuestionnaireQuestionsBuilder
include QuestionnaireDisplayElementsBuilder
# include QuestionnaireProfileAttributesBuilder

# APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
NAVIGATION = YAML.load_file("#{RAILS_ROOT}/config/navigation.yml")
QUESTIONNAIRE_CONTENT_TYPES = YAML.load_file("#{RAILS_ROOT}/config/questionnaire_content_types.yml")