* Settings *
Documentation    Arquivo contendo os casos de teste para o endpoint /produtos.
Resource         ../keywords/produtos_keywords.robot

Suite Setup      Run Keywords    Criar Sessao
...              AND             Carregar JSON    ${produtos_json}

* Test Cases *
#########################
#         GET           #
#     CT-P01 ~ CT-P03   #
#########################
CT-P01: GET Todos Os Produtos 200
    [Documentation]    Teste de listar todos os produtos com sucesso.
    [Tags]             GET    STATUS-2XX
    
    ${response}            Enviar GET    /produtos

    Validar Status Code    200    ${response}
    Log To Console         ${response.json()}


CT-P02: GET Buscar Produto Existente 200
    [Documentation]    Teste de busca de produto existente por id.
    [Tags]             GET    STATUS-2XX
    
    [Setup]            Preparar Novo Produto Estatico    produto_valido    ${json["dados_cadastro"]["produto_valido"]}
    
    ${response}                Enviar GET    /produtos/${registro_produtos.produto_valido}

    Validar Status Code        200    ${response}
    Validar Produto            ${response.json()}
    Validar Produtos Iguais    ${response.json()}    ${json["dados_cadastro"]["produto_valido"]}

    [Teardown]         Limpar Registro De Produtos


CT-P03: GET Tentar Buscar Produto Inexistente 400
    [Documentation]    Teste para tentativa de busca de produto por id inexistente.
    [Tags]             GET    STATUS-4XX

    ${id_produto}          Set Variable    naoexiste123

    ${response}            Enviar GET    /produtos/${id_produto}

    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}


#########################
#         POST          #
#     CT-P04 ~ CT-P08   #
#########################
CT-P04: POST Cadastrar Novo Produto 201
    [Documentation]    Teste de cadastrar um novo produto com sucesso.
    [Tags]             POST    STATUS-2XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true

    ${token_auth}               Fazer Login          ${registro_usuarios.user_admin}
    &{headers}                  Create Dictionary    Authorization=${token_auth}
    
    ${dados_produto}            Set Variable         ${json["dados_cadastro"]["produto_valido"]}

    ${response}                 Enviar POST          /produtos    ${dados_produto}    headers=${headers}

    Validar Status Code         201    ${response}
    Validar Mensagem            Cadastro realizado com sucesso    ${response}
    Should Not Be Empty         ${response.json()["_id"]}
    
    # Verifica se o produto foi realmente criado
    ${id_produto}               Set Variable    ${response.json()["_id"]}
    Validar Dados De Produto    ${id_produto}    ${dados_produto}

    [Teardown]         Run Keywords    
    ...                Deletar Produto    ${id_produto}    ${token_auth}
    ...    AND         Limpar Registro De Usuarios
    

CT-P05: POST Tentar Cadastrar Produto Com Nome Repetido 400
    [Documentation]    Teste para tentativa de cadastro de produto com nome já cadastrado.
    [Tags]             POST    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin        administrador=true
    ...    AND         Preparar Novo Produto Estatico    produto_valido    ${json["dados_cadastro"]["produto_valido"]}

    ${token_auth}                  Fazer Login                 ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary           Authorization=${token_auth}

    ${dados_produto}               Set Variable                ${json["dados_cadastro"]["produto_nome_repetido"]}

    ${num_produtos_inicial}        Obter Quantidade De Produtos

    ${response}                    Enviar POST    /produtos    ${dados_produto}    headers=${headers}

    Validar Status Code            400    ${response}
    Validar Mensagem               Já existe produto com esse nome    ${response}

    # Verifica se a quantidade de produtos permanece a mesma.
    ${num_produtos_final}          Obter Quantidade De Produtos
    Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios



CT-P06: POST Tentar Cadastrar Produto Sem Login 401
    [Documentation]    Teste para tentativa de cadastro de produto sem ter feito login.
    [Tags]             POST    STATUS-4XX
    
    ${dados_produto}               Set Variable     ${json["dados_cadastro"]["produto_valido"]}

    ${num_produtos_inicial}        Obter Quantidade De Produtos
    
    ${response}                    Enviar POST    /produtos    ${dados_produto}

    Validar Status Code            401    ${response}
    Validar Mensagem               Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                            ${response}

    # Verifica se a quantidade de produtos permanece a mesma.
    ${num_produtos_final}          Obter Quantidade De Produtos
    Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}


CT-P07: POST Tentar Cadastrar Produto Sem Ser Administrador 403
    [Documentation]    Teste para tentativa de cadastro de produto por usuário não-administrador.
    [Tags]             POST    STATUS-4XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_padrao    administrador=false

    ${token_auth}                  Fazer Login          ${registro_usuarios.user_padrao}
    &{headers}                     Create Dictionary    Authorization=${token_auth}

    ${dados_produto}               Set Variable         ${json["dados_cadastro"]["produto_valido"]}

    ${num_produtos_inicial}        Obter Quantidade De Produtos

    ${response}                    Enviar POST          /produtos    ${dados_produto}    headers=${headers}

    Validar Status Code            403    ${response}
    Validar Mensagem               Rota exclusiva para administradores    ${response}

    # Verifica se a quantidade de produtos permanece a mesma.
    ${num_produtos_final}          Obter Quantidade De Produtos
    Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}

    [Teardown]         Limpar Registro De Usuarios


CT-P08: POST Tentar Cadastrar Produto Com Dados Invalidos 400
    [Documentation]    Teste para tentativa de cadastro de produto com dados inválidos.
    ...                Os dados são gerados a partir de um modelo válido,
    ...                mas com entradas em branco, ou faltando.
    [Tags]             POST    STATUS-4XX

    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true

    ${token_auth}              Fazer Login              ${registro_usuarios.user_admin}
    &{headers}                 Create Dictionary        Authorization=${token_auth}

    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_cadastro"]["produto_valido"]}

    FOR  ${produto}  IN  @{dados_invalidos}
        Log To Console                 Testando: ${produto}
        ${num_produtos_inicial}        Obter Quantidade De Produtos

        ${response}                    Enviar POST    /produtos    ${produto}    headers=${headers}

        Validar Status Code            400    ${response}
        Log To Console                 ${response.json()}

        # Verifica se a quantidade de produtos permanece a mesma.
        ${num_produtos_final}          Obter Quantidade De Produtos
        Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}
    END

    [Teardown]         Limpar Registro De Usuarios
    

#########################
#         DELETE        #
#     CT-P09 ~ CT-P13   #
#########################
CT-P09: DELETE Excluir Produto Existente 200
    [Documentation]    Teste de excluir produto existente com sucesso.
    [Tags]             DELETE    STATUS-2XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin    administrador=true
    ...    AND         Preparar Novo Produto Dinamico    produto_inicial
    
    ${token_auth}          Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}             Create Dictionary               Authorization=${token_auth}


    ${response}            Enviar DELETE    /produtos/${registro_produtos.produto_inicial}    headers=${headers}

    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso    ${response}
    
    # Verifica se o produto foi realmente excluído
    ${response}            Enviar GET    /produtos/${registro_produtos.produto_inicial}

    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Usuarios
    ...    AND         Remover Produto Do Registro    produto_inicial


CT-P10: DELETE Tentar Excluir Produto Inexistente 200
    [Documentation]    Teste de tentativa de excluir produto inexistente.
    [Tags]             DELETE    STATUS-2XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true

    ${token_auth}                  Fazer Login          ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary    Authorization=${token_auth}

    ${id_produto}                  Set Variable         naoexiste123

    ${num_produtos_inicial}        Obter Quantidade De Produtos

    ${response}                    Enviar DELETE    /produtos/${id_produto}    headers=${headers}

    Validar Status Code            200    ${response}
    Validar Mensagem               Nenhum registro excluído    ${response}

    # Verifica se a quantidade de produtos permanece a mesma.
    ${num_produtos_final}          Obter Quantidade De Produtos
    Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}

    [Teardown]         Limpar Registro De Usuarios


CT-P11: DELETE Tentar Excluir Produto Em Carrinho 400
    [Documentation]    Teste de tentativa de excluir produto cadastrado em carrinho.
    [Tags]             DELETE    STATUS-4XX
    
    [Setup]            Preparar Produto Em Carrinho    
    
    ${token_auth}          Fazer Login          ${registro_usuarios.user_carrinho}
    &{headers}             Create Dictionary    Authorization=${token_auth}

    ${response}            Enviar DELETE    /produtos/${registro_produtos.produto_carrinho}    headers=${headers}

    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido excluir produto que faz parte de carrinho    ${response}
    Should Not Be Empty    ${response.json()["idCarrinhos"]}

    # Verifica se o produto realmente NÃO foi excluído
    ${response}            Enviar GET    /produtos/${registro_produtos.produto_carrinho}

    Validar Status Code    200    ${response}
    Validar Produto        ${response.json()}

    [Teardown]         Limpar Produto Em Carrinho


CT-P12: DELETE Tentar Excluir Produto Existente Sem Login 401
    [Documentation]    Teste de tentativa de excluir produto existente sem ter feito login.
    [Tags]             DELETE    STATUS-4XX
    
    [Setup]            Preparar Novo Produto Estatico    produto_valido    ${json["dados_cadastro"]["produto_valido"]}

    ${response}            Enviar DELETE    /produtos/${registro_produtos.produto_valido}

    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}

    # Verifica se o produto realmente NÃO foi excluído
    Validar Dados De Produto    ${registro_produtos.produto_valido}    ${json["dados_cadastro"]["produto_valido"]}

    [Teardown]         Limpar Registro De Produtos


CT-P13: DELETE Tentar Excluir Produto Existente Sem Ser Administrador 403
    [Documentation]    Teste de tentativa de excluir produto existente por usuário não-administrador.
    [Tags]             DELETE    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Produto Estatico    produto_valido    ${json["dados_cadastro"]["produto_valido"]}
    ...    AND         Preparar Novo Usuario Dinamico    user_padrao       administrador=false
    
    ${token_auth}              Fazer Login                     ${registro_usuarios.user_padrao}
    &{headers}                 Create Dictionary               Authorization=${token_auth}

    ${response}                Enviar DELETE    /produtos/${registro_produtos.produto_valido}    headers=${headers}

    Validar Status Code        403    ${response}
    Validar Mensagem           Rota exclusiva para administradores
    ...                        ${response}

    # Verifica se o produto realmente NÃO foi excluído
    Validar Dados De Produto    ${registro_produtos.produto_valido}    ${json["dados_cadastro"]["produto_valido"]}  

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


#########################
#         PUT           #
#     CT-P14 ~ CT-P23   #
#########################
CT-P14: PUT Editar Produto Existente 200
    [Documentation]    Teste de edição de um produto existente.
    [Tags]             PUT    STATUS-2XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin         administrador=true
    ...    AND         Preparar Novo Produto Estatico    produto_inicial    ${json["dados_edicao"]["produto_inicial"]}

    ${token_auth}          Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    ${novos_dados}         Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${response}            Enviar PUT    /produtos/${registro_produtos.produto_inicial}    ${novos_dados}    headers=${headers}

    Validar Status Code    200    ${response}
    Validar Mensagem       Registro alterado com sucesso    ${response}

    # Verifica se o produto foi realmente editado
    Validar Dados De Produto    ${registro_produtos.produto_inicial}    ${novos_dados}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-P15: PUT Tentar Editar Produto Inexistente 201
    [Documentation]    Teste de edição de um produto inexistente.
    [Tags]             PUT    STATUS-2XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true
 
    ${token_auth}               Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                  Create Dictionary               Authorization=${token_auth}

    ${id_produto}               Set Variable    naoexiste9432

    ${novos_dados}              Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${response}                 Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    Validar Status Code         201    ${response}
    Validar Mensagem            Cadastro realizado com sucesso    ${response}
    Should Not Be Empty         ${response.json()["_id"]}

    # Verifica se o produto foi realmente criado
    ${id_produto}               Set Variable     ${response.json()["_id"]}
    Validar Dados De Produto    ${id_produto}    ${novos_dados}

    [Teardown]         Run Keywords    
    ...                Deletar Produto    ${id_produto}    ${token_auth}
    ...    AND         Limpar Registro De Usuarios


CT-P16: PUT Tentar Editar Produto Existente Com Nome Repetido 400
    [Documentation]    Teste de tentativa de edição de um produto existente com
    ...                o nome de outro produto já cadastrado.
    [Tags]             PUT    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin          administrador=true
    ...    AND         Preparar Novo Produto Estatico    produto_repetido    ${json["dados_edicao"]["produto_nome_repetido"]}
    ...    AND         Preparar Novo Produto Estatico    produto_inicial     ${json["dados_edicao"]["produto_inicial"]}
    
    ${token_auth}               Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                  Create Dictionary               Authorization=${token_auth}

    ${novos_dados}              Set Variable    ${json["dados_edicao"]["edicao_nome_repetido"]}

    ${response}                 Enviar PUT    /produtos/${registro_produtos.produto_inicial}    ${novos_dados}    headers=${headers}

    Validar Status Code         400    ${response}
    Validar Mensagem            Já existe produto com esse nome    ${response}

    # Verifica se o produto realmente NÃO foi editado
    Validar Dados De Produto    ${registro_produtos.produto_inicial}    ${json["dados_edicao"]["produto_inicial"]}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-P17: PUT Tentar Editar Produto Inexistente Com Nome Repetido 400    
    [Documentation]    Teste de tentativa de edição de um produto inexistente com
    ...                o nome de outro produto já cadastrado.
    [Tags]             PUT    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin          administrador=true
    ...    AND         Preparar Novo Produto Estatico    produto_repetido    ${json["dados_edicao"]["produto_nome_repetido"]}

    ${token_auth}                  Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                     Create Dictionary               Authorization=${token_auth}

    ${id_produto_editado}          Set Variable    naoexiste123

    ${novos_dados}                 Set Variable    ${json["dados_edicao"]["edicao_nome_repetido"]}

    ${num_produtos_inicial}        Obter Quantidade De Produtos

    ${response}                    Enviar PUT    /produtos/${id_produto_editado}    ${novos_dados}    headers=${headers}

    Validar Status Code            400    ${response}
    Validar Mensagem               Já existe produto com esse nome    ${response}

    # Verifica se a quantidade de produtos permanece a mesma.
    ${num_produtos_final}          Obter Quantidade De Produtos
    Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-P18: PUT Tentar Editar Produto Existente Sem Login 401
    [Documentation]    Teste de edição de um produto existente sem ter feito login.
    [Tags]             PUT    STATUS-4XX
    
    [Setup]            Preparar Novo Produto Estatico    produto_inicial    ${json["dados_edicao"]["produto_inicial"]}

    ${novos_dados}         Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${response}            Enviar PUT    /produtos/${registro_produtos.produto_inicial}    ${novos_dados}

    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}

    # Verifica se o produto realmente NÃO foi editado
    Validar Dados De Produto    ${registro_produtos.produto_inicial}    ${json["dados_edicao"]["produto_inicial"]}

    [Teardown]         Limpar Registro De Produtos


CT-P19: PUT Tentar Editar Produto Inexistente Sem Login 401
    [Documentation]    Teste de edição de um produto existente sem ter feito login.
    [Tags]             PUT    STATUS-4XX
    
    ${id_produto}                  Set Variable    naoexiste1412

    ${novos_dados}                 Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${num_produtos_inicial}        Obter Quantidade De Produtos

    ${response}                    Enviar PUT    /produtos/${id_produto}    ${novos_dados}

    Validar Status Code            401    ${response}
    Validar Mensagem               Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                            ${response}

    # Verifica se a quantidade de produtos permanece a mesma.
    ${num_produtos_final}          Obter Quantidade De Produtos
    Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}


CT-P20: PUT Tentar Editar Produto Existente Sem Ser Administrador 403
    [Documentation]    Teste de edição de um produto existente por usuário não-administrador.
    [Tags]             PUT    STATUS-4XX

    [Setup]            Run Keywords   
    ...                Preparar Novo Usuario Dinamico    user_padrao        administrador=false
    ...    AND         Preparar Novo Produto Estatico    produto_inicial    ${json["dados_edicao"]["produto_inicial"]}

    ${novos_dados}           Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${token_auth}            Fazer Login                     ${registro_usuarios.user_padrao}
    &{headers}               Create Dictionary               Authorization=${token_auth}

    ${response}            Enviar PUT    /produtos/${registro_produtos.produto_inicial}    ${novos_dados}    headers=${headers}

    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}

    # Verifica se o produto realmente NÃO foi editado
    Validar Dados De Produto    ${registro_produtos.produto_inicial}    ${json["dados_edicao"]["produto_inicial"]}

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-P21: PUT Tentar Editar Produto Inexistente Sem Ser Administrador 403
    [Documentation]    Teste de edição de um produto existente por usuário não-administrador.
    [Tags]             PUT    STATUS-4XX
    
    [Setup]            Preparar Novo Usuario Dinamico    user_padrao    administrador=false

    ${id_produto}                    Set Variable    naoexiste10312

    ${novos_dados}                   Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${token_auth_padrao}             Fazer Login                     ${registro_usuarios.user_padrao}
    &{headers}                       Create Dictionary               Authorization=${token_auth_padrao}

    ${num_produtos_inicial}        Obter Quantidade De Produtos

    ${response}                    Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    Validar Status Code            403    ${response}
    Validar Mensagem               Rota exclusiva para administradores
    ...                            ${response}

    # Verifica se a quantidade de produtos permanece a mesma.
    ${num_produtos_final}          Obter Quantidade De Produtos
    Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}

    [Teardown]         Limpar Registro De Usuarios


CT-P22: PUT Tentar Editar Produto Existente Com Dados Invalidos 400
    [Documentation]    Teste para tentativa de edição de produto existente com dados inválidos.
    ...                Os dados são gerados a partir de um modelo válido,
    ...                mas com entradas em branco, ou faltando.
    [Tags]             PUT    STATUS-4XX

    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Dinamico    user_admin         administrador=true
    ...    AND         Preparar Novo Produto Estatico    produto_inicial    ${json["dados_edicao"]["produto_inicial"]}

    ${token_auth}              Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                 Create Dictionary               Authorization=${token_auth}

    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_cadastro"]["produto_valido"]}

    FOR  ${produto}  IN  @{dados_invalidos}
        Log To Console         Testando: ${produto}

        ${response}            Enviar PUT    /produtos/${registro_produtos.produto_inicial}    ${produto}    headers=${headers}
        Validar Status Code    400    ${response}
        Log To Console         ${response.json()}

        # Verifica se o produto realmente NÃO foi editado
        Validar Dados De Produto    ${registro_produtos.produto_inicial}    ${json["dados_edicao"]["produto_inicial"]}
    END

    [Teardown]         Run Keywords
    ...                Limpar Registro De Produtos
    ...    AND         Limpar Registro De Usuarios


CT-P23: PUT Tentar Editar Produto Inexistente Com Dados Invalidos 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com dados inválidos.
    ...                Os dados são gerados a partir de um modelo válido,
    ...                mas com entradas em branco, ou faltando.
    [Tags]             PUT    STATUS-4XX

    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true
    
    ${token_auth}              Fazer Login                     ${registro_usuarios.user_admin}
    &{headers}                 Create Dictionary               Authorization=${token_auth}

    ${id_produto}              Set Variable                    nao_existe12314
    
    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_cadastro"]["produto_valido"]}

    FOR  ${produto}  IN  @{dados_invalidos}
        Log To Console                 Testando: ${produto}
        ${num_produtos_inicial}        Obter Quantidade De Produtos

        ${response}                    Enviar PUT    /produtos/${id_produto}    ${produto}    headers=${headers}

        Validar Status Code            400    ${response}
        Log To Console                 ${response.json()}

        # Verifica se a quantidade de produtos permanece a mesma.
        ${num_produtos_final}          Obter Quantidade De Produtos
        Should Be Equal As Integers    ${num_produtos_inicial}    ${num_produtos_final}
    END

    [Teardown]         Limpar Registro De Usuarios

##########################################################################################