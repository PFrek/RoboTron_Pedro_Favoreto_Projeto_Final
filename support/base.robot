* Settings *
Documentation        Arquivo base para centralização de imports e resources.
Library              RequestsLibrary
Resource             ./common/common.robot
Resource             ./fixtures/dynamics.robot
Resource             ./variables/variables.robot

# Sessão para criação de Keywords Personalizadas
* Keywords *
Criar Sessao
    Create Session        serverest    ${BASE_URI}

# Gerenciamento de requisitos para testes -- Usuários
Preparar Novo Usuario Estatico
    [Documentation]    Cria um usuário a partir de dados json e adiciona
    ...                ao registro de usuários.
    [Arguments]        ${chave}    ${dados_usuario}

    ${id_usuario}        Cadastrar Usuario    ${dados_usuario}
    Set To Dictionary    ${registro_usuarios}    ${chave}=${id_usuario}

Preparar Novo Usuario Dinamico
    [Documentation]    Cria um usuário a partir de dados dinâmicos e adiciona
    ...                ao registro de usuários.
    [Arguments]        ${chave}    ${administrador}=true

    &{dados_usuario}     Criar Dados Usuario Dinamico    ${administrador}  
    ${id_usuario}        Cadastrar Usuario               ${dados_usuario}

    Set To Dictionary    ${registro_usuarios}    ${chave}=${id_usuario}

Limpar Registro De Usuarios
    [Documentation]    Deleta todos os usuários presentes no registro de usuários.
    
    FOR  ${chave}    ${id_usuario}  IN  &{registro_usuarios}
        Deletar Usuario    ${id_usuario}
    END

    Set Suite Variable    &{registro_usuarios}    &{EMPTY}

Remover Usuario Do Registro
    [Documentation]    Remove um usuário do registro de usuários.
    ...                Utilizado para casos em que o usuário já foi deletado.
    [Arguments]        ${chave}

    Remove From Dictionary    ${registro_usuarios}    ${chave}

# Gerenciamento de requisitos para testes -- Produtos
Preparar Novo Produto Estatico
    [Documentation]    Cria um produto a partir de dados json e adiciona
    ...                ao registro de produtos.
    [Arguments]        ${chave}    ${dados_produto}    
    
    &{dados_admin}       Criar Dados Usuario Dinamico    administrador=true
    ${id_admin}          Cadastrar Usuario    ${dados_admin}
    ${token_auth}        Fazer Login    ${id_admin}

    ${id_produto}        Cadastrar Produto    ${dados_produto}    ${token_auth}
    Set To Dictionary    ${registro_produtos}    ${chave}=${id_produto}

    Deletar Usuario      ${id_admin}

Preparar Novo Produto Dinamico
    [Documentation]    Cria um produto a partir de dados dinâmicos e adiciona
    ...                ao registro de produtos.
    [Arguments]        ${chave}    ${quantidade}=${100}

    &{dados_admin}       Criar Dados Usuario Dinamico    administrador=true
    ${id_admin}          Cadastrar Usuario    ${dados_admin}
    ${token_auth}        Fazer Login    ${id_admin}

    &{dados_produto}     Criar Dados Produto Dinamico    quantidade=${quantidade}  
    ${id_produto}        Cadastrar Produto            ${dados_produto}    ${token_auth}

    Set To Dictionary    ${registro_produtos}         ${chave}=${id_produto}

    Deletar Usuario      ${id_admin}

Limpar Registro De Produtos
    [Documentation]    Deleta todos os produtos presentes no registro de produtos.
    ...                \nRequer a id de um user admin válido.

    &{dados_admin}     Criar Dados Usuario Dinamico    administrador=true
    ${id_admin}        Cadastrar Usuario    ${dados_admin}
    ${token_auth}      Fazer Login    ${id_admin}

    FOR  ${chave}    ${id_produto}  IN  &{registro_produtos}
        Deletar Produto    ${id_produto}    ${token_auth}
    END

    Set Suite Variable    &{registro_produtos}    &{EMPTY}

    Deletar Usuario    ${id_admin}

Remover Produto Do Registro
    [Documentation]    Remove um produto do registro de produtos.
    ...                Utilizado para casos em que o usuário já foi deletado.
    [Arguments]        ${chave}

    Remove From Dictionary    ${registro_produtos}    ${chave}
