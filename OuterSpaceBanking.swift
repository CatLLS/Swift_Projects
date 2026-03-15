//Corpo de funções

//------Menus, chamam as outras funções e lidam com input-------------//
//MenuGlobal
func menuGlobal()->Void{
    print("O que deseja fazer em nossa estação?\n 1.Criar registro estelar(nova conta)\n 2.Logar por neural link\n 3.Desligar terminal")
    if let input = readLine(), let resposta=Int(input){
        switch resposta{
            case 1: print("Conta criada")
            case 2: print("Logado")
            case 3: return
            default: 
                print("Você vê o futuro? Nós ainda não temos nenhuma ação como essa disponível!\nOpção não encontrada, tente novamente")
                menuGlobal()
        }
    }else{
        print("Entrada inválida!")
        menuGlobal()
        }
} 

//MenuAdmin
//MenuUser
//MenuInvestimentos

//Main loop
menuGlobal()
