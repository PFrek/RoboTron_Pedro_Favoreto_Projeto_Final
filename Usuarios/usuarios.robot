* Settings *
Documentation    Arquivo contendo os testes para o endpoint /usuarios da API ServeRest.
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${endpoint}           /usuarios



* Test Cases *
Reset: Reinicializar Lista De Usuarios
    [Documentation]         Reinicializa a lista de usuários.
    ...                     \nO primeiro usuário é um usuário admin sem carrinho.
    ...                     \nO segundo usuário é um usuário padrão com carrinho.
    [Tags]                  Reset    #robot:skip

    Criar Sessao

    # Lista atual de usuários
    ${response}=            Enviar GET    ${endpoint}
    @{usuarios}=            Set Variable    ${response.json()["usuarios"]}
    
    # Para cada usuario da lista
    FOR  ${usuario}  IN  @{usuarios}
        # Excluir o usuario
        ${id}=              Set Variable    ${usuario["_id"]}
        ${response}=        Enviar DELETE    ${endpoint}/${id}
    END

    # Adiciona o usuário admin sem carrinho
    &{usuario}=        Criar Usuario Dinamico    nome=Fulano da Silva    email=beltrano@qa.com.br
    ...                password=teste    administrador=true
    ${response}=       Enviar POST    ${endpoint}    ${usuario}


    # Adiciona o usuário padrão com carrinho
    &{usuario}=        Criar Usuario Dinamico    nome=Com Carrinho    email=comcarrinho@qa.com.br
    ...                password=1234    administrador=false
    ${response}=       Enviar POST    ${endpoint}    ${usuario}

    # TODO - Adicionar carrinho ao usuario

    # &{login}=          Obter Informacoes De Login    &{usuario}

    # ${response}=       Enviar POST    /login    ${login}
    # ${token}=          Set Variable    ${response.json()["authorization"][7:]}
    # Log To Console     ${token}

    # # Cadastrar carrinho
    # &{headers}=        Create Dictionary    Authorization=${token}
    # &{body}=           Create Dictionary    produtos=@{EMPTY}
    # ${response}=       Enviar POST    /carrinhos    ${body}    headers=&{headers}
    


Cenario: GET Todos Os Usuarios 200
    [Documentation]         Teste de listar todos os usuários com sucesso.
    [Tags]                  GET

    Criar Sessao
    ${response}=            Enviar GET    ${endpoint}
    Validar Status Code     200    ${response}



Cenario: POST Cadastrar Novo Usuario 201
    [Documentation]        Teste de cadastrar um novo usuário com sucesso.
    [Tags]                 POST

    Criar Sessao

    # Cadastrar Usuario
    &{usuario}=                Criar Usuario Dinamico
    ${response}=               Enviar POST    ${endpoint}    ${usuario}
    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}
    
    # Validar que o usuario foi realmente criado
    # ID do usuário criado
    ${id}=                     Set Variable    ${response.json()["_id"]}
    ${response}=               Enviar GET    ${endpoint}/${id}
    Validar Status Code        200    ${response}
    Validar Usuarios Iguais    ${response.json()}    ${usuario}
    
    # Deletar usuario cadastrado
    # Permite que este teste seja repetido sem alterar informações do usuário
    Enviar DELETE              ${endpoint}/${id}
    
Cenario: POST Tentar Cadastrar Usuario Com Email Repetido 400
    [Documentation]          Teste para tentativa de cadastro com email já cadastrado.
    [Tags]                   POST

    Criar Sessao
    ${email}=                Obter Email Existente
    &{usuario}=              Criar Usuario Dinamico    nome_teste    ${email}    1234    true
    ${resposta}=             Enviar POST    ${endpoint}    ${usuario}
    Validar Status Code      400    ${resposta}
    Validar Mensagem         Este email já está sendo usado    ${resposta}

Cenario: POST Tentar Cadastrar Usuario Com Dados Inválidos 400
    [Documentation]        Teste para tentativa de cadastro com dados inválidos (email faltando).
    [Tags]                 POST

    Criar Sessao
    # Usuário com email faltando
    &{usuario}=            Create Dictionary    nome=nome    password=234    administrador=false
    ${resposta}=           Enviar POST    ${endpoint}    ${usuario}
    Validar Status Code    400    ${resposta}


Cenario: GET Buscar Usuario Existente 200
    [Documentation]        Teste de busca de usuário existente por id.
    [Tags]                 GET
    
    Criar Sessao
    &{usuario}=            Obter Dados De Usuario Existente
    ${id}=                 Set Variable    ${usuario["_id"]}
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    200    ${response}
    Log To Console         ${response.json()}


Cenario: GET Tentar Buscar Usuario Inexistente 400
    [Documentation]        Teste para tentativa de busca por id inexistente.
    [Tags]                 GET

    Criar Sessao
    ${id}=                 Set Variable    naoexiste123
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}



Cenario: DELETE Excluir Usuario Existente 200
    [Documentation]        Teste de excluir usuário existente.
    [Tags]                 DELETE

    Criar Sessao

    # Deletar usuário
    &{usuario}=            Obter Dados De Usuario Existente
    ${id}=                 Set Variable    ${usuario["_id"]}
    ${response}=           Enviar DELETE    ${endpoint}/${id}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso
    ...                    ${response}
    
    # Verifica se o usuário foi realmente excluído
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}

    # Re-cadastra o usuário excluído
    # Permite repetição do teste
    &{recadastro}=         Remover Campo ID    ${usuario}
    ${resposta}=           Enviar POST    ${endpoint}    ${recadastro}


# TODO - Tentar excluir usuário com carrinho
Cenario: DELETE Tentar Excluir Usuario Com Carrinho 400
    [Documentation]        Teste de tentativa de excluir usuário com carrinho cadastrado.
    [Tags]                 DELETE

    Skip                   Não implementado.


Cenario: DELETE Tentar Excluir Usuario Inexistente 200
    [Documentation]        Teste de tentativa de excluir usuário inexistente.
    [Tags]                 DELETE

    Criar Sessao

    ${id}=                 Set Variable    naoexiste123
    ${response}=           Enviar DELETE    ${endpoint}/${id}
    Validar Status Code    200    ${response}
    Validar Mensagem       Nenhum registro excluído    ${response}



Cenario: PUT Editar Usuario Existente 200
    [Documentation]        Teste de edição de um usuário existente.
    [Tags]                 PUT

    Criar Sessao

    &{novos_dados}=        Criar Usuario Dinamico    nome=Nome Editado    email=email_editado@teste.com.br
    ...                    password=4321    administrador=false

    &{usuario}=            Obter Dados De Usuario Existente
    ${id}=                 Set Variable    ${usuario["_id"]}

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${novos_dados}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro alterado com sucesso    ${response}

    # Verificar se o usuário foi realmente editado
    ${response}=           Enviar GET    ${endpoint}/${id}
    Validar Status Code    200    ${response}
    Validar Usuarios Iguais    ${response.json()}    ${novos_dados}

    # Retornar os dados antigos para o usuário
    # Permite repetição do teste
    &{dados_antigos}=      Remover Campo ID    ${usuario}

    ${response}=           Enviar PUT    ${endpoint}/${id}    ${dados_antigos}
    Validar Status Code    200    ${response}


Cenario: PUT Tentar Editar Usuario Existente Com Email Repetido 400
    [Documentation]        Teste de tentativa de edição de um usuário existente com
    ...                    o email de outro usuário já cadastrado.
    [Tags]                 PUT

    Criar Sessao

    # Usuário que será editado
    &{usuario_editado}=             Obter Dados De Usuario Existente    0
    ${id}=                          Set Variable    ${usuario_editado["_id"]}


    # Usuário de quem o email repetido será retirado
    &{usuario_email}=                     Obter Dados De Usuario Existente    1
    ${email}=                       Set Variable    ${usuario_email["email"]}

    # Altera o email a ser editado
    &{usuario_editado}=             Create Dictionary    nome=${usuario_editado["nome"]}
    ...                             email=${email}    password=${usuario_editado["password"]}
    ...                             administrador=${usuario_editado["administrador"]}
    
    ${response}=                    Enviar PUT    ${endpoint}/${id}    ${usuario_editado}
    Validar Status Code             400    ${response}
    Validar Mensagem                Este email já está sendo usado    ${response}


Cenario: PUT Tentar Editar Usuário Existente Com Dados Inválidos 400
    [Documentation]    Teste para tentativa de edição de usuário existente com dados inválidos.
    [Tags]             PUT

    Criar Sessao

    &{usuario_editado}=        Obter Dados De Usuario Existente
    ${id}=                     Set Variable    ${usuario_editado["_id"]}
    
    &{dados_invalidos}=        Create Dictionary    nome=Nome    idade=24

    ${response}=               Enviar PUT    ${endpoint}/${id}    ${dados_invalidos}
    Validar Status Code        400    ${response}





* Keywords *

# Listadas apenas keywords usadas unicamente nesta suíte de testes

Criar Usuario Dinamico
    [Documentation]    Cria um usuário com as informações passadas por argumento.
    ...                Se nenhum argumento for passado, usa informações pré-definidas.
    ...                \nRetorna: \&{usuario}
    
    [Arguments]        ${nome}=nome_teste    ${email}=email_teste@teste.com.br    ${password}=1234    ${administrador}=true
    &{usuario}=        Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    [Return]           &{usuario}

Remover Campo ID
    [Documentation]    Remove o campo '_id' de um usuário, para facilitar o recadastramento.
    
    [Arguments]        ${usuario}
    &{usuario}=        Create Dictionary    nome=${usuario["nome"]}    
    ...                email=${usuario["email"]}    password=${usuario["password"]}
    ...                administrador=${usuario["administrador"]}
    [Return]           &{usuario}


Obter Email Existente
    [Documentation]      Obtém o email do primeiro usuário da lista de usuários registrados.
    ...                  Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                  \nRetorna: \${email}

    &{usuario}=          Obter Dados De Usuario Existente
    &{login}=            Obter Informacoes De Login    &{usuario}
    ${email}=            Set Variable    ${login["email"]}
    [Return]             ${email}

Validar Usuarios Iguais
    [Documentation]        Verifica se dois usuários serverest possuem todos os campos iguais.

    [Arguments]            ${usuario_1}    ${usuario_2}
    Should Be Equal        ${usuario_1["nome"]}             ${usuario_2["nome"]}
    Should Be Equal        ${usuario_1["email"]}            ${usuario_2["email"]}
    Should Be Equal        ${usuario_1["password"]}         ${usuario_2["password"]}
    Should Be Equal        ${usuario_1["administrador"]}    ${usuario_2["administrador"]}