# RuboCop (Ruby)

`rubocop-aaa` es un cop personalizado de RuboCop que impone el patrón Arrange-Act-Assert en código de tests de Ruby.

## Instalación

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop-aaa', require: false
end
```

```bash
bundle install
```

## Habilitar el cop

```yaml
# .rubocop.yml
require:
  - rubocop-aaa

AAA/Pattern:
  Enabled: true
  Include:
    - 'spec/**/*.rb'
    - 'test/**/*.rb'
```

## Cop: `AAA/Pattern`

### Configuración

```yaml
AAA/Pattern:
  TestFunctions:
    - it
    - test
    - specify
    - example
  Labels:
    arrange: [arrange]
    act:     [act]
    assert:  [assert]
  CaseSensitive: false
  AllowEmptySection: true
```

### Ejemplos

#### Given / When / Then

```yaml
AAA/Pattern:
  Labels:
    arrange: [given]
    act:     [when]
    assert:  [then]
```

#### Español

```yaml
AAA/Pattern:
  Labels:
    arrange: [preparar, preparación]
    act:     [ejecutar]
    assert:  [verificar, comprobar]
```

### Qué detecta

```ruby
# Offense: falta "arrange"
it 'bad' do
  # act
  x = do_thing
  # assert
  expect(x).to eq(1)
end

# Offense: orden incorrecto
it 'also bad' do
  # act
  x = do_thing
  # arrange
  y = 1
  # assert
  expect(x).to eq(y)
end
```

## Auto-corrección

Cuando los tres comentarios de sección están **todos ausentes**, `rubocop -a` (o `--autocorrect`) inserta una plantilla `# arrange` / `# act` / `# assert` al inicio del bloque. Luego solo tienes que mover cada comentario sobre el código que le corresponde.

Otros casos (uno o dos ausentes, orden incorrecto, sección vacía) no se auto-corrigen — la posición correcta depende de la intención del test, y el mensaje de la offense te dice exactamente «qué» añadir y «dónde».
