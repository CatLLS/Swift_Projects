//criando o formato do usuário 
struct Usuario{
  var nome: String
  var senha: String
  var saldo: Double
  let id: Int
}

//-----------------Corpo de funções----------------------// 
func lerString(mensagem: String)-> String{
    while (true){
        print(mensagem, terminator: ": ")//para ele não colocar um \n no final
        if let entrada=readLine(), !entrada.isEmpty{
            return entrada
        }
        print("Pane de navegação! Entrada inválida para tipo esperado!")
    }
}
func lerInt(mensagem: String)->Int{
    while (true){
        print(mensagem, terminator: ": ")//para ele não colocar um \n no final
        if let entrada=readLine(), let entradaInt = Int(entrada){
            return entradaInt
        }
        print("Pane de navegação! Entrada inválida para tipo esperado!")
    }
}
func lerDouble(mensagem: String)->Double{
       while (true){
        print(mensagem, terminator: ": ")//para ele não colocar um \n no final
        if let entrada=readLine(), let entradaD = Double(entrada){
            return entradaD
        }
        print("Pane de navegação! Entrada inválida para tipo esperado!")
    }
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
    let i = lerInt(mensagem:"insira sua chave estelar única")
	if( !(encontrarUsuario(b,String(i),"id") == -1) ){
	    print("Sinto muito, esta chave já está registrada em nosso sistema, talvez você quisesse fazer login ao invés de criar uma conta nova?")
	    return
	}
	let nome = lerString(mensagem:"Insira seu nome")
	let senha = lerString(mensagem:"Insira sua senha")
	let saldo = lerDouble(mensagem:"Insira o saldo inicial(se não houver nenhum, digite 0)") 
	let novoUsuario = Usuario(nome: nome, senha:senha, saldo: saldo, id: i)
	b.append(novoUsuario)
	print("Conta criada com sucesso! Bem vindo a união estelar \(nome), seu código de identificação é \(novoUsuario.id)! utilize esta chave estelar única para logar!")
}

func fazerLogin(_ b: [Usuario])->Int{
    //retorno: -1=erro, 0=admin, else=id do user
    let id = lerString(mensagem:"Insira sua chave estelar de identificação")
    let senha = lerString(mensagem:"Insira sua senha")
    let posicao = encontrarUsuario(b,id,"id")
    if b[posicao].senha==senha {
        print("Bem vindo(a) \(b[posicao].nome)")
    }else{
        print("Intruso detectado: Senha incorreta. Tente novamente")
        return -1
    }
                
    switch posicao{
        case -1:
            print("Usuário \(id) não encontrado")
        case 0:
            print("\nHá quanto tem Admin! Sentimos sua falta, há muito trabalho a fazer...")
            return 0
        default:
            return posicao//normal user
    }

    return -1
}

func menuAdmin(_ baseDeDados: inout [Usuario])->Void{
    var goBack = false
    while (!goBack){
        let res = lerInt(mensagem:"Portal do Comandante:\n 1.Listar Todas as Contas\n 2.Deletar Conta\n 3.Logout\nR")
        switch res{
            case 1:
                for user in baseDeDados{
                    print("\nID: \(user.id) \n- Nome: \(user.nome) \n-Saldo: \(user.saldo)")
                }
            case 2:
                let chaveDeletar = lerString(mensagem:"Caro comandante, digite a chave estelar do usuário que deseja deletar")
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
            case 3: goBack = true
            default: 
                print("Você vê o futuro? Nós ainda não temos nenhuma ação como essa disponível!\nOpção não encontrada, tente novamente")
        }
    }
}

//retorna 0=sucesso, -1=erro
//idFonte 0=proibido, -1=depósito
//idDestino 0=proibido, -1=investimento(dinheiro vai para o banco)
func transferirGeral(valor: Double, idFonte: Int, idDestino: Int, bD: inout [Usuario])->Int{
    //id=0 não transfere nem recebe pq é uma contra administrativa
    if idFonte == 0 || idDestino == 0{
        return -1
    }
    if valor<0 {
        return -2
    }
    if idDestino == idFonte{
        return 0
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
        if bD[fonte].saldo < valor{return -2}
        bD[fonte].saldo -= valor
    }else{
        if bD[fonte].saldo < valor{return -2}
        bD[fonte].saldo -= valor
        bD[destino].saldo += valor
    }
    return 0
}

func menuUser(_ b: inout [Usuario], _ userID: Int)->Void{
    while(true){
        let res = lerInt(mensagem:"Hub Financeiro:\n 1.Status da Conta/ver saldo\n 2. Injetar Créditos - Depósito\n 3.Transferência de créditos\n 4.Central de investimentos\n 5.Logout\nR")
        switch res{
            case 1: 
                let user = b[userID]
                print("\nID: \(user.id) \n- Nome: \(user.nome) \n-Saldo: \(user.saldo)")//não mostra a senha de propósito, mas poderia
            case 2: 
                let valorDep = lerDouble(mensagem:"Insira a quantidade de créditos a serem depositados")
                let transf = transferirGeral(valor:valorDep, idFonte:-1, idDestino: userID, bD:&b)
                if  transf == -1{
                    print("Pane de navegação! Não foi possível fazer o depósito(transação proibida)")
                }else if transf == -2{
                    print("Pane de navegação! Saldo insuficiente")
                }else{
                    print("Depósito de \(valorDep) créditos feita com sucesso!")
                }
            case 3:
                let idDestinoTransf = lerInt(mensagem:"Insira a chave estelar de destino da transferência")
                let valorTransf = lerDouble(mensagem:"Insira a quantidade de créditos a serem transferidos")
                let transf = transferirGeral(valor:valorTransf, idFonte:userID, idDestino: idDestinoTransf, bD:&b)
                if  transf == -1{
                    print("Pane de navegação! Não foi possível efetuar a transação(transação proibida)")
                }else if transf == -2{
                    print("Pane de navegação! Saldo insuficiente")
                }else{
                    print("Transferência de \(valorTransf) créditos feita com sucesso!")
                }
            case 4: menuInvestimento(&b,userID)
            case 5: return
            default:  print("Você vê o futuro? Nós ainda não temos nenhuma ação como essa disponível!\nOpção não encontrada, tente novamente")
        }
    }
}
//menu investimento
func menuInvestimento(_ b: inout [Usuario],_ userID: Int)->Void{
	while(true){
		let resposta = lerInt(mensagem:"\nMercado de Futuros Galáticos:\n 1.Comprar starCoin - Crypto\n 2.Títulos de Mineração em Asteroides\n 3.Seguro Hiper-Espaço\n 4.Voltar\nR")
		switch resposta{
		    case 1:
		        let deseja = lerInt(mensagem: "1 moeda starCoin custa 622 créditos, deseja comprar?(1=sim, 0=não)\nR")
		        if deseja == 1{
		            let transf = transferirGeral(valor: 622, idFonte: userID , idDestino: -1, bD:&b)
		            if  transf == -1{
                    print("Pane de navegação! Não foi possível efetuar a transação(transação proibida)")
                    }else if transf == -2{
                        print("Pane de navegação! Saldo insuficiente")
                    }else{
                        print("Transação de 622 créditos feita com sucesso!")
                    }
		        }
		    case 2: 
		        let deseja = lerInt(mensagem: "1 título de mineração em asteróides custa 100 créditos, deseja comprar?(1=sim, 0=não)\nR")
		        if deseja == 1{
		            let transf = transferirGeral(valor: 100, idFonte: userID , idDestino: -1, bD:&b) 
		            if  transf == -1{
                        print("Pane de navegação! Não foi possível efetuar a transação(transação proibida)")
                    }else if transf == -2{
                        print("Pane de navegação! Saldo insuficiente")
                    }else{
                        print("Transação de 100 créditos feita com sucesso!")
                    }
		        }
		    case 3: 
		        let deseja = lerInt(mensagem: "1 pacote de Seguro Hiper-Espaço custa 10.000 créditos, deseja comprar?(1=sim, 0=não)\nR")
		        if deseja == 1{
		            let transf = transferirGeral(valor: 10000, idFonte: userID , idDestino: -1, bD:&b) 
		            if  transf == -1{
                        print("Pane de navegação! Não foi possível efetuar a transação(transação proibida)")
                    }else if transf == -2{
                        print("Pane de navegação! Saldo insuficiente")
                    }else{
                        print("Transação de 10.000 créditos feita com sucesso!")
                    }
		        }
		    case 4: return
		    default: print("Você vê o futuro? Nós ainda não temos nenhuma ação como essa disponível!\nOpção não encontrada, tente novamente")
	    }
	}
}


//--------------------MAIN-LOOP--------------------------//
var baseDeDados: [Usuario] = [
Usuario(nome:"ADMIN", senha: "1234", saldo: 0, id: 0000),
Usuario(nome: "testuser622", senha: "4567", saldo: 10, id: 0001)
]
var proximoID = 2
var sistemaAtivo=true
while sistemaAtivo{
	let resposta = lerInt(mensagem:"\nO que deseja fazer em nossa estação?\n 1.Criar registro estelar(nova conta)\n 2.Logar por neural link\n 3.Desligar terminal\nR")
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
	
}
print("Obrigado por usar o sistema bancário interestelar Lumen Nexus!")
