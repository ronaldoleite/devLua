local json = require("json")

-- Função para carregar os dados da TODO list a partir de um arquivo JSON
local function carregarLista(nomeArquivo)
    local arquivo = io.open(nomeArquivo, "r")
    if not arquivo then
        return {}
    end
    local conteudo = arquivo:read("*a")
    arquivo:close()
    return json.decode(conteudo)
end

-- Função para salvar os dados da TODO list em um arquivo JSON
local function salvarLista(lista, nomeArquivo)
    local arquivo = io.open(nomeArquivo, "w")
    if arquivo then
        arquivo:write(json.encode(lista))
        arquivo:close()
    else
        print("Erro ao abrir o arquivo para salvar.")
    end
end

-- Função para adicionar um item na lista
local function adicionarItem(lista, nome)
    local novoItem = {
        id = #lista + 1,
        nome = nome,
        status = "pendente"
    }
    table.insert(lista, novoItem)
    return novoItem
end

-- Função para remover um item da lista pelo ID
local function removerItem(lista, id)
    for i, item in ipairs(lista) do
        if item.id == id then
            table.remove(lista, i)
            return true
        end
    end
    return false
end

-- Função para atualizar o status de um item na lista pelo ID
local function atualizarStatus(lista, id, novoStatus)
    for _, item in ipairs(lista) do
        if item.id == id then
            item.status = novoStatus
            return true
        end
    end
    return false
end

-- Função para exibir todos os itens na lista com seus respectivos status
local function exibirLista(lista)
    print("TODO list:")
    for _, item in ipairs(lista) do
        print(string.format("ID: %d, Nome: %s, Status: %s", item.id, item.nome, item.status))
    end
end

-- Função principal
local function main()
    local arquivoLista = "todo_list.json"
    local lista = carregarLista(arquivoLista)

    while true do
        print("\nO que você deseja fazer?")
        print("1. Adicionar item")
        print("2. Remover item")
        print("3. Atualizar status de item")
        print("4. Ver todos os items")
        print("5. Sair")

        local opcao = io.read("*n")1
        io.read()  -- Limpar o buffer de entrada

        if opcao == 1 then
            print("Digite o nome do novo item:")
            local nomeItem = io.read()
            adicionarItem(lista, nomeItem)
            print("Item adicionado com sucesso!")
        elseif opcao == 2 then
            print("Digite o ID do item que deseja remover:")
            local idItem = io.read("*n")
            if removerItem(lista, idItem) then
                print("Item removido com sucesso!")
            else
                print("ID do item não encontrado.")
            end
        elseif opcao == 3 then
            print("Digite o ID do item que deseja atualizar:")
            local idItem = io.read("*n")
            print("Digite o novo status (pendente/concluido):")
            local novoStatus = io.read()
            if atualizarStatus(lista, idItem, novoStatus) then
                print("Status atualizado com sucesso!")
            else
                print("ID do item não encontrado.")
            end
        elseif opcao == 4 then
            exibirLista(lista)
        elseif opcao == 5 then
            print("Saindo...")
            salvarLista(lista, arquivoLista)
            break
        else
            print("Opção inválida. Por favor, escolha uma opção válida.")
        end
    end
end

main()
