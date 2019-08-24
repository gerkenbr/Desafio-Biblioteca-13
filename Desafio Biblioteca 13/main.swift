//
//  main.swift
//  Desafio Biblioteca 13
//
//  Created by XCodeClub on 20/08/19.
//  Copyright © 2019 Alexandre Gerken Brasil. All rights reserved.
//

import Foundation

// Desafio Biblioteca

//Parte 1:
//1.Crie  um  diagrama  de  classes  que  modele  um  objeto  Livro.  Lembre-se  de  que  ele NÃO representa uma cópia específica de um livro, mas da obra de forma abstrata.Como regra geral, um livro deve ter nome (String), um código ISBN (Int) e um autor (String).
//2.Implemente a classe criando os atributos e construtores que forem necessários. 3.No Playground, crie três objetos Livro.

class Exemplar: Livro {
    // Tive que deslocar estaa classe para o comeco para eliminar erro ao compilar na classe livro
    
    let nroEdicao: Int
    var localizacao: String
    var nroIdentificacao: Int
    var livroOriginal: Livro
    
    init(livroOriginal: Livro, nroEdicao: Int, localizacao: String, nroIdentificaco: Int) {
        self.nroEdicao = nroEdicao
        self.localizacao = localizacao
        self.nroIdentificacao = nroIdentificaco
        self.livroOriginal = livroOriginal
        super.init(nome: livroOriginal.nome, codigoISBN: livroOriginal.codigoISBN, autor: livroOriginal.autor)
        livroOriginal.listaDeExemplares.append(self)
    }
    
}


class Livro {
    let nome: String
    let codigoISBN: Int
    let autor: String
    var listaDeExemplares: [Exemplar] = []
    
    init(nome: String, codigoISBN: Int, autor: String) {
        self.nome = nome
        self.codigoISBN = codigoISBN
        self.autor = autor
    }
    
    func adicionarExemplar(umExemplar : Exemplar) -> Void {
        self.listaDeExemplares.append(umExemplar)
    }
    
    func temExemplaresDisponíveis() -> Bool {
        switch self.listaDeExemplares.isEmpty {
        case false: // se "isEmpty" for false, quer dizer que  lista TEM exemplares disponiveis e devolve TRUE
            print("tem exemplares disponiveis")
            return true
        case true:
            print("nao tem exemplares disponiveis")
            return false
            
        }
    }
    
    func removerExemplar() -> Exemplar? {
        
        var exemplarRemovido: Exemplar?
        
        if !self.listaDeExemplares.isEmpty {
            exemplarRemovido = self.listaDeExemplares.removeFirst()
        } else {
            print("Não há exemplares disponíveis")
            return nil
        }
        
        return exemplarRemovido!
        // o optional sempre retornara um Exemplar, portanto usei o "forced unwrap"
    }
    
    func receberExemplar(umExemplar : Exemplar) -> Void {
        self.listaDeExemplares.append(umExemplar)
        print("O exemplar com identificacao \(umExemplar.nroIdentificacao) foi adicionado à lista dos exemplares do livro \(self.nome)")
    }
}


//Parte 2:
// 1.Crie um diagrama de classe que represente um modelo de sócio de uma biblioteca.Como  regra  geral,  um  sócio  deve  ter  um  nome (String),  um  sobrenome (String) e um número de identificação (Int).
//2.Implemente a classe criando os atributos e construtores que forem necessários.
//3.No Playground, crie três objetos Sócio.



enum TipodeSocio {
    case socioNormal
    case socioVIP
}

class Socio {
    let nomeSocio: String
    let sobrenomeSocio: String
    let numeroIdentificacaco: Int
    var tipoDeSocio: TipodeSocio
    var qtdeMaxRetirada: Int
    var mensalidade: Double = 0 {
        didSet(newMensalidade) {
            if self.tipoDeSocio == .socioVIP {
                self.mensalidade = newMensalidade
            } else {
                self.mensalidade = 0
                print("O socio \(self.nomeSocio) é sócio comum e nao paga mensalidade")
            }
        }
    }
    var listaExemplaresRetirados: [Exemplar] = []
    
    init(nomeSocio: String, sobrenomeSocio: String, numeroIdentificacao: Int, tipoDeSocio: TipodeSocio, mensalidade: Double = 0) {
        self.nomeSocio = nomeSocio
        self.sobrenomeSocio = sobrenomeSocio
        self.numeroIdentificacaco = numeroIdentificacao
        self.tipoDeSocio = tipoDeSocio
        if self.tipoDeSocio == .socioVIP {
            self.mensalidade = mensalidade
            self.qtdeMaxRetirada = 15
        } else {
            self.mensalidade = 0
            self.qtdeMaxRetirada = 3
        }
    }
    
    func podeRetirar() -> Bool {
        var podeRetirar: Bool = false
        
        if self.listaExemplaresRetirados.count < self.qtdeMaxRetirada {
            podeRetirar = true
            print("O Socio pode ainda retirar \(self.qtdeMaxRetirada - self.listaExemplaresRetirados.count) livros")
            
        } else {
            podeRetirar = false
            print("O socio nao pode mais retirar livros. Ja retirou \(self.qtdeMaxRetirada)")
        }
        
        return podeRetirar
    }
    
    func pegarEmprestado(umExemplar: Exemplar) -> Void {
        
        if self.podeRetirar() == true {
            let exemplarRetirado: Exemplar = umExemplar.livroOriginal.removerExemplar()!
            self.listaExemplaresRetirados.append(exemplarRetirado)
        } else {
            print("O Socio nao conseguiu retirar o livro")
        }
    }
    
    func devolver(umExemplar : Exemplar) -> Void {
        if self.listaExemplaresRetirados.contains(where: {$0 === umExemplar}) {
            self.listaExemplaresRetirados.remove(at: self.listaExemplaresRetirados.firstIndex{$0 === umExemplar}!)
            umExemplar.livroOriginal.receberExemplar(umExemplar: umExemplar)
            print("O Sócio \(self.nomeSocio) devolveu o exemmplar do livro \(umExemplar.nome)")
        } else {
            print("O Sócio não retirou o exemplar do livro \(umExemplar.nome)")
        }
    }
}





//Parte 3: Queremos adicionar ao modelo anterior uma nova categoria de sócios: os sócios VIP. Além de  um  nome,  um  sobrenome  e  um  número  de  identificação,  estes  sócios  têm  um  valor  de mensalidade (Int).
//1.Como você modificaria o diagrama de sócio criado anteriormente?
//2.Modifique  a  implementação  considerando  os  novos  requisitos.  Crie  as  classes  que forem necessárias.
//3.Crie os atributos necessários.
//4.No Playground, crie dois objetos SócioVIP.

// Parte tres resolvida e atualizada na classe Socio

//Parte 4:
//1.Crie um diagrama de classes com um modelo de exemplar da biblioteca. Lembre-se de  que  um  exemplar  representa  uma  cópia  e  uma  edição  particulares  de  um  livro específico.Como  regra  geral,  um  exemplar  deve  ter  um  Livro (Livro),  um  número  de  edição (Int), uma localização (String) e um número de identificação (Int).
//2.Implemente a classe criando os atributos necessários.
//3.No Playground, crie exemplares diferentes para cada Livro criado





// Parte 5:
//Além  de  ter nome,  código  ISBN  e  autor,  o  livro  de  uma  biblioteca  possui  uma  lista  de exemplares ([Exemplar]) disponíveis para empréstimo.
//1.Como você modificaria o diagrama de livro criado anteriormente?
//2.Modifique a implementação considerando os novos requisitos.

// mudancas iplementadas nas classes Livro e Exemplares


//Parte 6:
//Além  de  ter nome,  sobrenome  e  número  de  identificação,  um  sócio  de  uma  biblioteca possui  uma  lista  de  exemplares  retirados ([Exemplar])e  uma  quantidade  máxima  de  livros que podem ser retirados.(Int). Um sócio comum pode retirar até 3 livros. Por outro lado, um sócio VIP pode retirar até 15 livros.
//1.Como você modificaria os diagramas de sócio e sócio VIP criados anteriormente?
//2.Modifique a implementação considerando os novos requisitos.

// mudancas implementadas na classe socio

//Parte 7:
//1.Na classe Livro, crie um método que permita adicionar um novo exemplar de livro à lista de exemplares disponíveis. ○adicionar(umExemplar : Exemplar) -> Void
//2.Na classe Livro, crie um método que permita consultar se há exemplares disponíveis de um livro. Se houver exemplares disponíveis na lista, este método deverá retornar true. Caso contrário, deverá retornar false.  ○temExemplaresDisponíveis() -> Bool
//3.Na  classe  Livro,  crie  um  método  que  permita  emprestar  um  exemplar  de  um  livro. Este  método  deve  remover  o  primeiro  exemplar  da  lista  de  exemplares  disponíveis (assumindo que a lista NÃO está vazia) e retorná-lo. ○removerExemplar() -> Exemplar
//4.Na  classe  Livro,  crie  um  método  que  permita  registrar  o  recebimento  de  um exemplar  que  foi  emprestado  a  um  sócio.  Este  método  deve  adicionar  o  primeiro exemplar recebido como parâmetro à lista de exemplares disponíveis. ○receber(umExemplar : Exemplar) -> Void
//5.No Playground, adicione os Exemplares criados aos seus Livros correspondentes.

// mudancas implementadas na classe livro. Obs: Meu inicializador para a classe Exemplar, já inclui a adicao do mesmo na lista de exemplares.

// Parte 8:
/*
 1. Na classe Sócio, crie um método que permita consultar se um sócio tem capacidade disponível para retirar um livro. Este método retorna true se tiver capacidade (ou seja, menos exemplares retirados do que os permitidos) e false se não tiver capacidade.
 
 Atenção: Lembre-se de que um sócio comum pode retirar apenas três exemplares, enquanto um sócio VIP pode retirar até 15 livros. ○ temCapacidadeDisponível() -> Bool 
 2. Na classe Sócio, crie um método que permita que o sócio pegue emprestado um exemplar. Isso significa que o método deverá adicionar o exemplar enviado por parâmetro à lista de exemplares retirados do sócio. ○ pegarEmprestado(umExemplar : Exemplar) -> Void 
 3. Na classe Sócio, crie um método que permita devolver um exemplar. Isso significa que o método deverá eliminar o exemplar recebido por parâmetro da lista de exemplares retirados, já que ele foi devolvido pelo sócio.  ○ devolver(umExemplar : Exemplar) -> Void */

// modificacoes feitas na classe docio

// Parte 9:  Agregue ao modelo anterior uma representação do objeto Empréstimo, que representa o empréstimo de um exemplar a um sócio. Como regra geral, o objeto deve ter um exemplar (Exemplar), um sócio (Sócio) e uma data (Data). Não é necessário registrar a data de término do empréstimo.
//1. Modifique o diagrama de classes e modele a classe Empréstimo.  
//2. Implemente a classe criando os atributos necessários.
//3. Crie um construtor que tome o sócio e o exemplar como parâmetro e construa um empréstimo com a data do dia. A classe Date permite utilizar datas em Swift. Para criar a data do dia basta instanciar um novo objeto usando Date().

class Emprestimo {
    var exemplarDoEmprestimo: Exemplar
    var socioDoEmprestimo: Socio
    var dataDoEmprestimo: Date
    
    init(socio: Socio, exemplar: Exemplar) {
        self.socioDoEmprestimo =  socio
        self.exemplarDoEmprestimo = exemplar
        self.dataDoEmprestimo = Date()
        print("Foi criado emprestimo do exemplar \(exemplar.livroOriginal.nome) para o socio \(socio.nomeSocio)")
    }
}


//Parte 10:  Por último, queremos adicionar uma representação da Biblioteca ao modelo anterior. Uma biblioteca tem uma lista de livros ([Livro]), uma lista de sócios ([Sócio]) e uma lista de empréstimos efetuados ([Empréstimo]).
//1. Modifique o diagrama de classes para que modele o objeto Biblioteca.
//2. Implemente a classe criando os atributos necessários.

class Biblioteca {
    let nomeDaBiblioteca: String
    var listaDeSocios: [Socio] = [Socio]()
    var listaDeEmprestimos: [Emprestimo] = [Emprestimo]()
    var listaDeLivros: [Livro] = [Livro]()
    
    init(nomeDaBiblioteca: String) {
        self.nomeDaBiblioteca = nomeDaBiblioteca
    }
    func registrar(socio: Socio...) {
        for socioAtual in socio {
            listaDeSocios.append(socioAtual)
        }
    }
    func registrar(livro: Livro...) {
        for livroAtual in livro {
            listaDeLivros.append(livroAtual)
        }
    }
    
    func existeSocio(idSócio: Int) -> Socio? {
        var socioConfirmado: Socio?
        for socioAtual in self.listaDeSocios {
            if socioAtual.numeroIdentificacaco == idSócio {
                socioConfirmado = socioAtual
            }
        }
        return socioConfirmado
    }
    
    func emprestar(isbnLivro: Int, idSócio: Int) -> Void {
        var achouLivro: Bool = false
        var achouSocio: Bool = false
        var temExemplar: Bool = false
        var podeEmprestar: Bool = false
        
        var livroAEmprestar: Livro?
        var exemplarARetirar: Exemplar?
        
        for livroAtual in self.listaDeLivros {
            if livroAtual.codigoISBN == isbnLivro {
                livroAEmprestar = livroAtual
                achouLivro = true
            }
        }
        if livroAEmprestar == nil {
            print("O livro com ISBN \(isbnLivro) não existe")
        }
        
        let socioQueEmpresta: Socio? = self.existeSocio(idSócio: idSócio) ?? nil
        if socioQueEmpresta != nil {
            achouSocio = true
        } else { print("O socio com ID \(idSócio) não existe") }
        
        if achouLivro == true && achouSocio == true {
            temExemplar = livroAEmprestar?.temExemplaresDisponíveis() ?? false
            podeEmprestar = socioQueEmpresta?.podeRetirar() ?? false
        }
        if temExemplar == true && podeEmprestar == true {
            exemplarARetirar = livroAEmprestar?.listaDeExemplares[0]
            
            // seleciona o primeiro exemplar disponivel
            socioQueEmpresta?.pegarEmprestado(umExemplar: exemplarARetirar!)
            print("emprestou")
            listaDeEmprestimos.append(Emprestimo(socio: socioQueEmpresta!, exemplar: exemplarARetirar!))
        }
    }
    
    func emprestar(listaDoSBNs: [Int], idSócio:Int) -> Void {
        let socioQueEmpresta: Socio? = self.existeSocio(idSócio: idSócio)
        if socioQueEmpresta != nil {
            for isbn in listaDoSBNs {
                self.emprestar(isbnLivro: isbn, idSócio: idSócio)
            }
        } else { print("Socio não existe na biblioteca")}
    }
    
    func retornar(umExemplar: Exemplar, idSócio: Int) -> Void {
        var socioQueDevolve: Socio?
        var livroDevolvido: Livro?
        for socioAtual in listaDeSocios {
            if socioAtual.numeroIdentificacaco == idSócio {
                socioQueDevolve = socioAtual
            }
        }
        for livroAtual in listaDeLivros {
            if umExemplar.livroOriginal === livroAtual {
                livroDevolvido = livroAtual
            }
        }
        if socioQueDevolve != nil && livroDevolvido != nil {
            socioQueDevolve?.devolver(umExemplar: umExemplar)
        }
        if socioQueDevolve == nil {
            print("o socio de id \(idSócio) não existe")
        }
        if livroDevolvido == nil {
            print("o exemplar \(umExemplar.nome) não pertence à biblioteca \(self.nomeDaBiblioteca)")
        }
    }
    
    func retornar(listaDeExemplares: [Exemplar], idSócio: Int) -> Void {
        
        let socioQueDevolve: Socio? = self.existeSocio(idSócio: idSócio)
        if socioQueDevolve != nil {
            
            for exemplarAtual in listaDeExemplares {
                socioQueDevolve?.devolver(umExemplar: exemplarAtual)
            }
        } else { print("O socio com ID \(idSócio) não existe nesta biblioteca")}
    }
    
}

//Parte 11:
//1. Crie um método na classe Biblioteca que permita registrar um sócio. ○ registrar(sócio: Sócio) -> Void
//2. Crie um método na classe Biblioteca que permita registrar um livro. ○ registrar(livro:Livro) -> Void
//3. Na classe Biblioteca, crie um método que permita emprestar um exemplar do livro solicitado pelo sócio. O resultado da operação deve ser impresso na tela. ○ emprestar(isbnLivro: Int, idSócio: Int) -> Void . Em primeiro lugar, o método deve: ● Procurar o livro na lista de livros da biblioteca (usando o ISBN enviado por parâmetro). Armazená-lo em uma variável. ● Procurar o sócio na lista de sócios (usando o número de identificação enviado por parâmetro). Armazená-lo em uma variável.  Em seguida, ele deverá conferir: ● Se o livro tem exemplares disponíveis. ● Se o sócio tem capacidade disponível.  Em caso afirmativo, ou seja, se as condições anteriores forem verdadeiras, deve-se: ● Procurar um exemplar do livro a emprestar.
//  Usar os métodos já definidos em Livro. ● Registrar que o sócio retirou esse exemplar.
//  Usar os métodos já definidos em Sócio. ● Criar um objeto Empréstimo, carregar nele as informações necessárias e adicioná-lo ao registro de empréstimos da Biblioteca.
// 4. Crie um método na classe Biblioteca que permita registrar a devolução de um exemplar. O resultado da operação deve ser impresso na tela. ○ retornar (umExemplar: Exemplar, idSócio: Int) -> Void . O método deve: ● Percorrer a lista de sócios, comparando se o número de identificação passado por parâmetro corresponde ao número de identificação de algum sócio na lista. Assim que o sócio for encontrado, registrar que devolveu o exemplar. ● Percorrer a lista de sócios, comparando se o livro do exemplar passado por parâmetro corresponde a algum da lista. Assim que o livro correspondente ao exemplar for encontrado, registrar o recebimento do exemplar.
//  5. No Playground, crie um objeto Biblioteca e registrar os Sócios e os Livros criados

var biblioteca1 = Biblioteca(nomeDaBiblioteca: "Arquivo Nacional")

var livro1 = Livro(nome: "Excel VBA", codigoISBN: 123456765, autor: "John Kaufmann")
var livro2 = Livro(nome: "Appollo Guidance Computer", codigoISBN: 345324567, autor: "Kevin Little")
var livro3 = Livro(nome: "Onde os Aviôes Morrem", codigoISBN: 654345678, autor: "Lito Souza")

biblioteca1.registrar(livro: livro1,livro2,livro3)

print(livro1.nome, livro2.nome, livro3.nome)

var socio1 = Socio(nomeSocio: "Alexandre", sobrenomeSocio: "Brasil", numeroIdentificacao: 111, tipoDeSocio: .socioNormal)
var socio2 = Socio(nomeSocio: "Henrique", sobrenomeSocio: "Gerken", numeroIdentificacao: 222, tipoDeSocio: .socioNormal)
var socio3 = Socio(nomeSocio: "Bettina", sobrenomeSocio: "Gerken", numeroIdentificacao: 333, tipoDeSocio: .socioNormal)
var socio4 = Socio(nomeSocio: "Joao", sobrenomeSocio: "Xavier", numeroIdentificacao: 444, tipoDeSocio: .socioVIP, mensalidade: 100.0)
var socio5 = Socio(nomeSocio: "Ligia", sobrenomeSocio: "Barbosa", numeroIdentificacao: 555, tipoDeSocio: .socioVIP, mensalidade: 150.0)

var exemplar1 = Exemplar(livroOriginal: livro1, nroEdicao: 1, localizacao: "Secao 1", nroIdentificaco: 1)
var exemplar2 = Exemplar(livroOriginal: livro1, nroEdicao: 3, localizacao: "Secao 1", nroIdentificaco: 4)
var exemplar3 = Exemplar(livroOriginal: livro1, nroEdicao: 5, localizacao: "Secao 1", nroIdentificaco: 5)
var exemplar4 = Exemplar(livroOriginal: livro2, nroEdicao: 10, localizacao: "Secao 2", nroIdentificaco: 2)
var exemplar5 = Exemplar(livroOriginal: livro2, nroEdicao: 12, localizacao: "Secao 2", nroIdentificaco: 6)
var exemplar6 = Exemplar(livroOriginal: livro2, nroEdicao: 15, localizacao: "Secao 2", nroIdentificaco: 7)
var exemplar7 = Exemplar(livroOriginal: livro3, nroEdicao: 2, localizacao: "Secao 3", nroIdentificaco: 3)
var exemplar8 = Exemplar(livroOriginal: livro3, nroEdicao: 2, localizacao: "Secao 3", nroIdentificaco: 8)
var exemplar9 = Exemplar(livroOriginal: livro3, nroEdicao: 2, localizacao: "Secao 3", nroIdentificaco: 9)

print(exemplar1.self, exemplar1.nome, exemplar1.autor, exemplar1.codigoISBN, exemplar1.localizacao, exemplar1.nroEdicao, exemplar1.nroIdentificacao)

for exemplarAtual in (livro1.listaDeExemplares) {
    print(exemplarAtual.nome, exemplarAtual.nroIdentificacao)
}
/*
 var emprestimo1 = Emprestimo(socio: socio1, exemplar: exemplar1)
 print(emprestimo1.dataDoEmprestimo)
 print(emprestimo1.dataDoEmprestimo.description)
 */

biblioteca1.registrar(socio: socio1,socio2,socio3,socio4,socio5)
print(biblioteca1.listaDeSocios)
socio1.mensalidade = 100 // tentei atribuir mensalidade para um socio comum, mas o "didSet" verifica e nao deixa
print("A mensalidade do socio \(socio1.nomeSocio) é \(socio1.mensalidade)") //confirma que a mensalidade ainda é zero

biblioteca1.emprestar(listaDoSBNs: [345324567,654345678], idSócio: 333)

for exemplar in socio3.listaExemplaresRetirados {
    print(exemplar.nroIdentificacao)
}

biblioteca1.retornar(listaDeExemplares: [exemplar4,exemplar7], idSócio: 333)

// Parte 12:
//1. Na classe Biblioteca, crie um método que permita emprestar um exemplar de cada livro da lista de ISBN solicitada pelo sócio. emprestar(listaDoSBNs: [Int], idSócio: Int) -> Void 
//  Para cada ISBN da lista, o método deve:  ● Procurar o livro na lista de livros da biblioteca usando o ISBN enviado por parâmetro. Armazená-lo em uma variável. ● Procurar o sócio na lista de sócios usando o número de identificação enviado por parâmetro. Armazená-lo em uma variável.  Em seguida, ele deverá conferir: ○ Se o livro tem exemplares disponíveis. ○ Se o sócio tem capacidade disponível.  Em caso afirmativo, ou seja, se as condições anteriores forem verdadeiras, deve-se: ○ Procurar um exemplar do livro a emprestar. Usar os métodos já definidos em Livro. ○ Registrar que o sócio retirou esse exemplar. Usar os métodos já definidos em Sócio. ○ Criar um objeto Empréstimo, carregar nele as informações necessárias e adicioná-lo ao registro de empréstimos da Biblioteca. Imprima na tela o resultado do empréstimo.
// ESCLARECIMENTO: Lembre-se dos métodos realizados anteriormente. O sócio levará os exemplares dos livros que estiverem disponíveis. Caso haja um exemplar de um livro que não possa ser retirado, essa informação será exibida na tela.
//2. Crie um método que permita registrar a devolução de uma lista de exemplares. Esse método não retorna nada. ○ retornar(listaDeExemplares: [Exemplar], idSócio: Int) -> Void Para cada exemplar, o método deve: ○ Registrar que o sócio devolveu o exemplar. ○ Registrar que o exemplar foi recebido na biblioteca. Imprima na tela o resultado do empréstimo.
//3. No Playground, simule empréstimos e devoluções.

// mudanças efetuadas nas devidas classes

//Parte 13 A Biblioteca está incorporando uma classificação de seus livros por categoria, para mostrar ao usuário a lista de livros disponíveis em cada categoria.
//1. Crie um diagrama de classes com o modelo do objeto Categoria. Como regra geral, uma categoria deve ter um nome (String), um código (Int) e uma descrição (String).
//2. Implemente a classe Categoria definindo os atributos necessários.
//3. Modifique a classe Biblioteca da seguinte forma: ○ adicionando uma lista de categorias, onde todas são registradas. ○ adicionando um dicionário com chaves, que serão os códigos das categorias, e valores, que serão uma lista de livros associados a essa categoria.
//4. Implemente os métodos a seguir:○ registrar(categoria: Categoria) -> Void  que deve adicionar a categoria recebida por parâmetro à lista de categorias. ○ adicionar(umLivro: Livro, a umaCategoria: Categoria) -> Void que deve receber como parâmetros uma categoria e um livro, e adicionar o livro ao dicionário com a categoria correspondente. Se a categoria não existir, crie a categoria e a lista ao adicionar o livro.  ○ listarLivros(de umaCategoria: Categoria) -> [Livro] que deve receber como parâmetro uma categoria e retornar uma lista com todos os livros que pertencem a essa categoria. ○ informarCategoria(de umLivro: Livro) -> Categoria? que deve receber um livro como parâmetro e retornar a categoria a qual ele pertence.
