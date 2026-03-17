//criando o formato do usuário 
struct Usuario{
  var nome: String
  var senha: String
  var saldo: Double
  let id: Int
}

//-----------------Corpo de funções----------------------// 
func lerEntrada(mensagem: String)-> String?{
    print(mensagem, terminator: ": ")//para ele não colocar um \n no final
    return readLine()
}

func encontrarUsuario(_ baseDeDados: [Usuario], _ info: String, _ tipoInfo: String)->Int{
        switch tipoInfo{
        case "nome":
            for (id,user) in baseDeDados.enumerated(){
                if user.nome == info {return id}
            }
        case "senha":
            for (id,user) in baseDeDados.enumerated(){
                if user.senha == info {return id}
            }
        case "saldo":
            let dInfo = Double(info)
            for (id,user) in baseDeDados.enumerated(){
                if user.saldo == dInfo {return id}
            }
        case "id":
            let iInfo = Int(info)
            for (id,user) in baseDeDados.enumerated(){
                if user.id == iInfo {return id}
            }
        default: return -1
        }
        return -1
}

func criarConta(_ b: inout [Usuario])->Void{
	guard       let nome = lerEntrada(mensagem:"Insira seu nome"),
	            let i = lerEntrada(mensagem:"insira sua chave estelar única(tipo cpf: 111111111)"), let id = Int(i),
				let senha = lerEntrada(mensagem:"Insira sua senha"),
				let saldoString = lerEntrada(mensagem:"Insira o saldo inicial(se não houver nenhum, digite 0)"), 
				let saldoNum = Double(saldoString) 
				else{
					print("Erro: Entrada inválida para tipo esperado!")
					return
				}
	let novoUsuario = Usuario(nome: nome, senha:senha, saldo: saldoNum, id: id)
	b.append(novoUsuario)
	print("Conta criada com sucesso! Bem vindo a união estelar \(nome), seu código de identificação é \(novoUsuario.id)! utilize esta chave estelar única para logar!")
}

func fazerLogin(_ b: [Usuario])->Int{
    //retorno: -1=erro, 0=admin, else=id do user
    guard   let id = lerEntrada(mensagem:"Insira sua chave estelar de identificação"),
            let senha = lerEntrada(mensagem:"Insira sua senha")
            else{
                print("Erro: Entrada inválida para tipo esperado!")
				return -1//not user
            }
    let posicao = encontrarUsuario(b,id,"id")
    switch posicao{
        case -1:
            print("Usuário \(id) não encontrado")
        case 0:
            print("\nHá quanto tem Admin! Sentimos sua falta, há muito trabalho a fazer...")
            return 0
        default:
            if b[posicao].senha==senha {
                print("Bem vindo(a) \(b[posicao].nome)")
                return posicao//normal user
            }
            print("Intruso detectado: Senha incorreta. Tente novamente")
    }
    return -1
}

func menuAdmin(_ baseDeDados: inout [Usuario])->Void{ //é melhor fazer em loop?
    guard let res = lerEntrada(mensagem:"Portal do Comandante:\n 1.Listar Todas as Contas\n 2.Deletar Conta\n 3.Logout\nR"), let resI = Int(res) else{
        print("Entrada inválida, tente novamente.")
        menuAdmin(&baseDeDados)
        return
    }
    switch resI{
        case 1:
            for user in baseDeDados{
                print("\nID: \(user.id) \n- Nome: \(user.nome) \n-Saldo: \(user.saldo)")
            }
        case 2:
            guard let chaveDeletar = lerEntrada(mensagem:"Caro comandante, digite a chave estelar do usuário que deseja deletar") else{
                print("Entrada inválida, tente novamente.")
                menuAdmin(&baseDeDados)
                return
            }
            if chaveDeletar == "0"{
                print("\nCaro Admin, a união estelar não permitirá sua demissão tão cedo!")
            }else{
                let cD = encontrarUsuario(baseDeDados,chaveDeletar,"id")
                if cD != -1{
                    print("Usuário: \(baseDeDados[cD].nome) deletado com sucesso!")
                    baseDeDados.remove(at: cD)
                }else{
                    print("Usuário não encontrado, tente novamente.")
                }
            }
        case 3: return
        default: 
            print("Você vê o futuro? Nós ainda não temos nenhuma ação como essa disponível!\nOpção não encontrada, tente novamente")
    }
    menuAdmin(&baseDeDados)
}

//retorna 0=sucesso, -1=erro
//idFonte 0=proibido, -1=depósito
//idDestino 0=proibido, -1=investimento(dinheiro vai para o banco)
func transferirGeral(valor: Double, idFonte: Int, idDestino: Int, bD: inout [Usuario])->Int{
    //id=0 não transfere nem recebe pq é uma contra administrativa
    if idFonte == 0 || idDestino == 0 || valor<0 || idDestino == idFonte{
        return -1
    }
    // 2. Localizar os índices na base de dados
    let fonte = (encontrarUsuario(bD, String(idFonte),"id"))
    let destino = (encontrarUsuario(bD, String(idDestino),"id"))
    // 3. Validação de existência
    if idFonte != -1 && fonte == -1{return -1}//não depósito e não tem fonte
    if idDestino != -1 && destino == -1{return -1}//não é investimento e não tem destino
    //4. Execução da transação
    if idFonte == -1{//quando id = -1 significa que é depósito, pq a fonte é externa
        bD[destino].saldo += valor
    }else if idDestino == -1{//investimento (dinheiro vai para o banco
        if bD[destino].saldo < valor{return -1}
        bD[fonte].saldo -= valor
    }else{
        if bD[destino].saldo < valor{return -1}
        bD[fonte].saldo -= valor
        bD[destino].saldo += valor
    }
    return 0
}

func menuUser(_ b: inout [Usuario], _ userID: Int)->Void{
    guard let res = lerEntrada(mensagem:"Hub Financeiro:\n 1.Status da Conta/ver saldo\n2. Injetar Créditos - Depósito\n 3.Transferência de créditos\n 4.Central de investimentos\n 5.Logout ") else{
        print("Entrada inválida, tente novamente.")
        menuUser(&b,userID)
        return
    }
    switch res{
        case "1": 
            let user = b[userID]
            print("\nID: \(user.id) \n- Nome: \(user.nome) \n-Saldo: \(user.saldo)")//não mostra a senha de propósito, mas poderia
        case "2": 
            guard let valorDepStr = lerEntrada(mensagem:"Insira a quantidade de créditos a serem depositados"), 
                let valorDep = Double(valorDepStr) else{
                print("Entrada inválida, tente novamente.")
                menuUser(&b,userID)
                return
            }
            if transferirGeral(valor:valorDep, idFonte:-1, idDestino: userID, bD:&b) == -1 {
                print("Erro: por algum motivo não foi possível fazer a transferência")
            }
        case "3":
            guard   let idDestinoTransfStr = lerEntrada(mensagem:"Insira a chave estelar de destino da transferência"),
                    let valorTransfStr = lerEntrada(mensagem:"Insira a quantidade de créditos a serem transferidos"),
                    let idDestinoTransf = Int(idDestinoTransfStr),
                    let valorTransf = Double(valorTransfStr)
            else{
                print("Entrada inválida, tente novamente.")
                menuUser(&b,userID)
                return
            }
            if transferirGeral(valor:valorTransf, idFonte:userID, idDestino: idDestinoTransf, bD:&b) == -1 {
                print("Erro: por algum motivo não foi possível fazer a transferência")
            }
        case "4": menuInvestimento()
        case "5": return
        default:  print("Você vê o futuro? Nós ainda não temos nenhuma ação como essa disponível!\nOpção não encontrada, tente novamente")
    }
}
//menu investimento
func menuInvestimento()->Void{}

//--------------------MAIN-LOOP--------------------------//
var baseDeDados: [Usuario] = [
Usuario(nome:"ADMIN", senha: "1234", saldo: 0, id: 0000),
Usuario(nome: "testuser622", senha: "4567", saldo: 10, id: 0001)
]
var proximoID = 2
var sistemaAtivo=true
while sistemaAtivo{
	if let input = lerEntrada(mensagem:"\nO que deseja fazer em nossa estação?\n 1.Criar registro estelar(nova conta)\n 2.Logar por neural link\n 3.Desligar terminal\nR"), let resposta = Int(input){
		switch resposta{
			case 1: criarConta(&baseDeDados)
			case 2: let respostaLogin = fazerLogin(baseDeDados)
			    switch respostaLogin{
			        case -1: continue
			        case 0: menuAdmin(&baseDeDados)
			        default: menuUser(&baseDeDados, respostaLogin)
			    }
			case 3: sistemaAtivo=false
			default: 
				print("Você vê o futuro? Nós ainda não temos nenhuma ação como essa disponível!\nOpção não encontrada, tente novamente")
		}
	}else{
		print("Entrada inválida! tente novamente")
	}
}
print("Obrigado por usar o sistema bancário interestelar Lumen Nexus!")
