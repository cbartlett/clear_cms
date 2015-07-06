
# Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder
# commenting out this bootstrap builder config because it leaks into the main app's formtastic config.
# instead we're modifying over default formtastic html with CSS, like before.
# but if bootstrap html structure is needed in future, best alternative is to specify:
# :builder => FormtasticBootstrap::FormBuilder on semantic_form_for &
# :builder => NestedForm::FormtasticBootstrapBuilder on nested_semantic forms for everywhere in ClearCMS
# this would make ClearCMS agnostic of any other app's default Formtastic builders (right now it's using the global config, so another app's implementation could break the forms)
# only reason for not changing it right now is to avoid refactoring

