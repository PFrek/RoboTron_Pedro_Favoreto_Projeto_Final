* Settings *
Documentation    Arquivo contendo os testes para o endpoint /produtos da API ServeRest.
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${endpoint}           /produtos
${email_admin}        fulano@qa.com.br
${senha_admin}        teste
${email_padrao}       comcarrinho@qa.com.br
${senha_padrao}       1234

* Test Cases *

Cenario: GET Todos Os Produtos 200
    [Documentation]        Teste de listar todos os produtos com sucesso.
    [Tags]                 GET

    Criar Sessao
    ${response}=           Enviar GET    ${endpoint}
    Validar Status Code    200    ${response}



Cenario: POST Cadastrar Novo Produto 201
    [Documentation]       Teste de cadastrar um novo produto com sucesso.
    [Tags]                POST

    Criar Sessao

    # Cadastrar produto
    &{produto}=                Criar Dados De Produto
    
    ${token}=                  Fazer Login Com Administrador
    &{headers}=                Create Dictionary    Authorization=${token}

    ${response}=               Enviar POST    ${endpoint}    ${produto}    headers=${headers}
    Validar Status Code        201    ${response}
    
    # Validar que o produto foi realmente criado
    # ID do produto criado
    ${id}=                     Set Variable    ${response.json()["_id"]}
    ${response}=               Enviar GET    ${endpoint}/${id}
    Validar Status Code        200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${produto}

    # Deletar produto cadastrado
    # Permite que este teste seja repetido sem alterar informações do produto
    Enviar DELETE              ${endpoint}/${id}    headers=${headers}
    

Cenario: POST Tentar Cadastrar Produto Com Nome Repetido 400
    [Documentation]          Teste para tentativa de cadastro de produto com nome já cadastrado.
    [Tags]                   POST

    Criar Sessao
    ${nome}=                 Obter Nome Existente
    &{produto}=              Criar Dados De Produto    ${nome}    ${200}    Nome repetido    ${100}

    ${token}=                Fazer Login Com Administrador
    &{headers}=              Create Dictionary    Authorization=${token}

    ${response}=             Enviar POST    ${endpoint}    ${produto}    headers=${headers}
    Validar Status Code      400    ${response}
    Validar Mensagem         Já existe produto com esse nome    ${response}


Cenario: POST Tentar Cadastrar Produto Com Dados Inválidos 400
    [Documentation]        Teste para tentativa de cadastro de produto com dados inválidos (preco faltando).
    [Tags]                 POST

    Criar Sessao
    # Produto com preco faltando
    &{produto}=            Create Dictionary    nome=nome    descricao=Preco faltando    quantidade=${10}
    
    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}
    
    ${response}=           Enviar POST    ${endpoint}    ${produto}    headers=${headers}
    Validar Status Code    400    ${response}


Cenario: POST Tentar Cadastrar Produto Sem Login 401
    [Documentation]        Teste para tentativa de cadastro de produto sem ter feito login.
    [Tags]                 POST

    Criar Sessao
    &{produto}=            Criar Dados De Produto

    ${response}=           Enviar POST    ${endpoint}    ${produto}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}


Cenario: POST Tentar Cadastrar Produto Sem Ser Administrador 403
    [Documentation]        Teste para tentativa de cadastro de produto por usuário não-administrador.
    [Tags]                 POST

    Criar Sessao
    &{produto}=            Criar Dados De Produto

    ${token}=              Fazer Login Com Usuario Padrao
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar POST    ${endpoint}    ${produto}    headers=${headers}
    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores    ${response}



Cenario: GET Buscar Produto Existente 200
    [Documentation]        Teste de busca de produto existente por id.
    [Tags]                 GET
    
    Criar Sessao
    &{produto}=            Obter Dados De Produto Existente
    ${id}=                 Set Variable    ${produto["_id"]}
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    200    ${response}
    Log To Console         ${response.json()}


Cenario: GET Tentar Buscar Produto Inexistente 400
    [Documentation]        Teste para tentativa de busca de produto por id inexistente.
    [Tags]                 GET

    Criar Sessao
    ${id}=                 Set Variable    naoexiste123
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}



Cenario: DELETE Excluir Produto Existente 200
    [Documentation]        Teste de excluir produto existente com sucesso.
    [Tags]                 DELETE

    Criar Sessao

    # Criar novo produto, garante que não estará em carrinho
    &{produto}=            Criar Dados De Produto

    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar POST    ${endpoint}    ${produto}    headers=${headers}
    Validar Status Code    201    ${response}
    ${id}=                 Set Variable    ${response.json()["_id"]}

    # Deletar produto
    ${response}=           Enviar DELETE    ${endpoint}/${id}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso
    ...                    ${response}
    
    # Verifica se o produto foi realmente excluído
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}


# TODO - Obter ID do produto dinamicamente
Cenario: DELETE Tentar Excluir Produto Em Carrinho 400
    [Documentation]        Teste de tentativa de excluir produto cadastrado em carrinho.
    [Tags]                 DELETE

    ${id}=                 Set Variable    BeeJh5lz3k6kSIzA

    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar DELETE    ${endpoint}/${id}    headers=${headers}

    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido excluir produto que faz parte de carrinho    ${response}


Cenario: DELETE Tentar Excluir Produto Inexistente 200
    [Documentation]        Teste de tentativa de excluir produto inexistente.
    [Tags]                 DELETE

    Criar Sessao

    ${id}=                 Set Variable    naoexiste123

    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar DELETE    ${endpoint}/${id}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Nenhum registro excluído    ${response}


Cenario: DELETE Tentar Excluir Produto Existente Sem Login 401
    [Documentation]        Teste de tentativa de excluir produto existente sem ter feito login.
    [Tags]                 DELETE

    Criar Sessao

    # Criar novo produto, garante que não estará em carrinho
    &{produto}=            Criar Dados De Produto

    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar POST    ${endpoint}    ${produto}    headers=${headers}
    Validar Status Code    201    ${response}
    ${id}=                 Set Variable    ${response.json()["_id"]}

    # Deletar produto sem login
    ${response}=           Enviar DELETE    ${endpoint}/${id}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}



    # Deletar produto, permite que o teste seja repetido sem alterar os dados
    ${response}=           Enviar DELETE    ${endpoint}/${id}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso
    ...                    ${response}


Cenario: DELETE Tentar Excluir Produto Existente Sem Ser Administrador 403
    [Documentation]        Teste de tentativa de excluir produto existente por usuário não-administrador.
    [Tags]                 DELETE

    Criar Sessao

    # Criar novo produto, garante que não estará em carrinho
    &{produto}=            Criar Dados De Produto

    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar POST    ${endpoint}    ${produto}    headers=${headers}
    Validar Status Code    201    ${response}
    ${id}=                 Set Variable    ${response.json()["_id"]}

    # Deletar produto sem ser administrador
    ${token}=              Fazer Login Com Usuario Padrao
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar DELETE    ${endpoint}/${id}    headers=${headers}
    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}



    # Deletar produto, permite que o teste seja repetido sem alterar os dados
    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar DELETE    ${endpoint}/${id}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso
    ...                    ${response}


Cenario: PUT Editar Produto Existente 200
    [Documentation]        Teste de edição de um produto existente.
    [Tags]                 PUT

    Criar Sessao

    &{novos_dados}=        Criar Dados De Produto    nome=Nome Editado    preco=${120}
    ...                    descricao=Descricao editada    quantidade=${50}

    &{produto}=            Obter Dados De Produto Existente
    ${id}=                 Set Variable    ${produto["_id"]}

    ${token}=              Fazer Login Com Administrador
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${novos_dados}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro alterado com sucesso    ${response}

    # Verificar se o produto foi realmente editado
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${novos_dados}

    # Retornar os dados antigos para o produto
    # Permite repetição do teste
    &{dados_antigos}=      Remover Campo ID    ${produto}

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${dados_antigos}    headers=${headers}
    Validar Status Code    200    ${response}


Cenario: PUT Tentar Editar Produto Existente Com Nome Repetido 400
    [Documentation]        Teste de tentativa de edição de um produto existente com
    ...                    o nome de outro produto já cadastrado.
    [Tags]                 PUT

    Criar Sessao

    # Produto que será editado
    &{produto_editado}=             Obter Dados De Produto Existente    0
    ${id}=                          Set Variable    ${produto_editado["_id"]}


    # Produto de quem o nome repetido será retirado
    &{produto_nome}=                Obter Dados De Produto Existente    1
    ${nome}=                        Set Variable    ${produto_nome["nome"]}

    # Altera o nome a ser editado
    &{produto_editado}=             Create Dictionary    nome=${nome}
    ...                             preco=${15}    descricao=Nova descricao
    ...                             quantidade=${90}
    
    ${token}=                       Fazer Login Com Administrador
    &{headers}=                     Create Dictionary    Authorization=${token}

    ${response}=                    Enviar PUT    ${endpoint}/${id}    ${produto_editado}    headers=${headers}
    Validar Status Code             400    ${response}
    Validar Mensagem                Já existe produto com esse nome    ${response}


Cenario: PUT Tentar Editar Produto Existente Com Dados Inválidos 400
    [Documentation]    Teste para tentativa de edição de produto existente com dados inválidos.
    [Tags]             PUT

    Criar Sessao

    &{produto_editado}=        Obter Dados De Produto Existente
    ${id}=                     Set Variable    ${produto_editado["_id"]}
    
    &{dados_invalidos}=        Create Dictionary    nome=Produto Inválido    modelo=A2

    ${token}=                  Fazer Login Com Administrador
    &{headers}=                Create Dictionary    Authorization=${token}

    ${response}=               Enviar PUT    ${endpoint}/${id}    ${dados_invalidos}    headers=${headers}
    Validar Status Code        400    ${response}


Cenario: PUT Tentar Editar Produto Inexistente 201
    [Documentation]    Teste para tentativa de edição de produto inexistente.
    [Tags]             PUT

    Criar Sessao

    &{produto}=                Criar Dados De Produto    nome=Novo Produto    preco=${200}
    ...                        descricao=Produto novo cadastrado    quantidade=${50}

    ${id}=                     Set Variable    id_nao_existe

    ${token}=                  Fazer Login Com Administrador
    &{headers}=                Create Dictionary    Authorization=${token}

    ${response}=               Enviar PUT    ${endpoint}/${id}    ${produto}    headers=${headers}
    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}
    ${id}=                     Set Variable    ${response.json()["_id"]}

    ${response}=               Enviar GET    ${endpoint}/${id}
    Validar Status Code        200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${produto}

    # Deletar produto, permite que o teste seja repetido sem alterar os dados
    ${response}=               Enviar DELETE    ${endpoint}/${id}    headers=${headers} 
    Validar Status Code        200    ${response}


Cenario: PUT Tentar Editar Produt Inexistente Com Nome Repetido 400
    [Documentation]    Teste para tentativa de edição de produto inexistente utilizando nome já cadastrado.
    [Tags]             PUT

    ${nome}=                   Obter Nome Existente
    &{produto}=                Criar Dados De Produto    nome=${nome}    preco=${25}
    ...                        descricao=Produto com nome repetido    quantidade=${15}

    ${id}=                     Set Variable    id_nao_existe

    ${token}=                  Fazer Login Com Administrador
    &{headers}=                Create Dictionary    Authorization=${token}

    ${response}=               Enviar PUT    ${endpoint}/${id}    ${produto}    headers=${headers}
    Validar Status Code        400    ${response}
    Validar Mensagem           Já existe produto com esse nome    ${response}


Cenario: PUT Tentar Editar Produto Inexistente Com Dados Inválidos 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com dados inválidos.
    [Tags]             PUT

    Criar Sessao

    ${id}=                     Set Variable    id_nao_existe
    
    &{dados_invalidos}=        Create Dictionary    nome=Produto Inválido    modelo=A2

    ${token}=                  Fazer Login Com Administrador
    &{headers}=                Create Dictionary    Authorization=${token}

    ${response}=               Enviar PUT    ${endpoint}/${id}    ${dados_invalidos}    headers=${headers}
    Validar Status Code        400    ${response}


Cenario: PUT Tentar Editar Produto Existente Sem Login 401
    [Documentation]        Teste de edição de um produto existente sem ter feito login.
    [Tags]                 PUT

    Criar Sessao

    &{novos_dados}=        Criar Dados De Produto    nome=Nome Editado    preco=${120}
    ...                    descricao=Descricao editada    quantidade=${50}

    &{produto}=            Obter Dados De Produto Existente
    ${id}=                 Set Variable    ${produto["_id"]}

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${novos_dados}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}


Cenario: PUT Tentar Editar Produto Inexistente Sem Login 401
    [Documentation]    Teste para tentativa de edição de produto inexistente sem ter feito login.
    [Tags]             PUT

    Criar Sessao

    &{produto}=            Criar Dados De Produto    nome=Novo Produto    preco=${200}
    ...                    descricao=Produto novo cadastrado    quantidade=${50}

    ${id}=                 Set Variable    id_nao_existe

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${produto}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}


Cenario: PUT Tentar Editar Produto Existente Sem Ser Administrador 403
    [Documentation]        Teste de edição de um produto existente por usuário não-administrador.
    [Tags]                 PUT

    Criar Sessao

    &{novos_dados}=        Criar Dados De Produto    nome=Nome Editado    preco=${120}
    ...                    descricao=Descricao editada    quantidade=${50}

    &{produto}=            Obter Dados De Produto Existente
    ${id}=                 Set Variable    ${produto["_id"]}

    ${token}=              Fazer Login Com Usuario Padrao
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${novos_dados}    headers=${headers}
    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}


Cenario: PUT Tentar Editar Produto Inexistente Sem Ser Administrador 403
    [Documentation]    Teste para tentativa de edição de produto inexistente por usuário não-administrador.
    [Tags]             PUT

    Criar Sessao

    &{produto}=            Criar Dados De Produto    nome=Novo Produto    preco=${200}
    ...                    descricao=Produto novo cadastrado    quantidade=${50}

    ${id}=                 Set Variable    id_nao_existe

    ${token}=              Fazer Login Com Usuario Padrao
    &{headers}=            Create Dictionary    Authorization=${token}

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${produto}    headers=${headers}
    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}


* Keywords *

# Listadas apenas keywords usadas unicamente nesta suíte de testes

Criar Dados De Produto
    [Documentation]    Cria um produto com as informações passadas por argumento.
    ...                Se nenhum argumento for passado, usa informações pré-definidas.
    ...                \nRetorna: \&{produto}

    [Arguments]        ${nome}=Headset Audio Ex    ${preco}=${200}    ${descricao}=Headset    ${quantidade}=${100}
    &{produto}=        Create Dictionary    nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    [Return]           &{produto}

Remover Campo ID
    [Documentation]    Remove o campo '_id' de um produto, para facilitar o recadastramento.
    
    [Arguments]        ${produto}
    &{produto}=        Create Dictionary    nome=${produto["nome"]}    
    ...                preco=${produto["preco"]}    descricao=${produto["descricao"]}
    ...                quantidade=${produto["quantidade"]}
    [Return]           &{produto}


Obter Nome Existente
    [Documentation]      Obtém o nome do primeiro produto da lista de produtos registrados.
    ...                  Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                  \nRetorna: \${nome}

    &{produto}=          Obter Dados De Produto Existente
    ${nome}=             Set Variable    ${produto["nome"]}
    [Return]             ${nome}

Fazer Login Com Administrador
    [Documentation]      Realiza login com um usuário administrador.
    ...                  Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                  \nRetorna: \${token}

    &{login}=            Create Dictionary    email=${email_admin}    password=${senha_admin}
    ${response}=         Enviar POST    /login    ${login}
    ${token}=            Set Variable    ${response.json()["authorization"]}
    [Return]             ${token}

Fazer Login Com Usuario Padrao
    [Documentation]      Realiza login com um usuário não-administrador.
    ...                  Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                  \nRetorna: \${token}

    &{login}=            Create Dictionary    email=${email_padrao}    password=${senha_padrao}
    ${response}=         Enviar POST    /login    ${login}
    ${token}=            Set Variable    ${response.json()["authorization"]}
    [Return]             ${token}

Validar Produtos Iguais
    [Documentation]      Verifica se dois produtos serverest possuem todos os campos iguais.

    [Arguments]          ${produto_1}    ${produto_2}
    Should Be Equal      ${produto_1["nome"]}    ${produto_2["nome"]}
    Should Be Equal      ${produto_1["preco"]}    ${produto_2["preco"]}
    Should Be Equal      ${produto_1["descricao"]}    ${produto_2["descricao"]}
    Should Be Equal      ${produto_1["quantidade"]}    ${produto_2["quantidade"]}
