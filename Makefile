#  Universidade Federal do Rio de Janeiro
#  Escola Politecnica
#  Departamento de Eletronica e de Computacao
#  EEL - Arq. Comp - Turma 2023/2
#  Prof. Diego
#  Grupo: Andre Pereira, Davi Hetch, Marco Antônio
#  Descricao: DGEMM

CC = gcc
CFLAGS = -Wall -std=c11

# Programa principal
DGEMM_FIRST = dgemm_first
DGEMM_FIRST_OBJ = dgemm_first.o


# Programas de testes
#TESTE_DGEMM_FIRST = teste
#TESTE_DGEMM_FIRST_OBJ = $(DGEMM_FIRST_OBJ) teste_dgemm_first.o


# Todos os testes
#TESTES = $(TESTE) $(TESTE_INSERIR) $(TESTE_BUSCA) $(TESTE_IMPRIME)

# Regra implicita
.c.o: 
	$(CC) $(CFLAGS) -c $< 

##### Programa principal #####
$(DGEMM_FIRST): $(DGEMM_FIRST_OBJ)
	$(CC) $(CFLAGS) $(DGEMM_FIRST_OBJ) -o $@

##########  TESTES ###########
$(TESTE): $(TESTE_OBJ)
	$(CPP) $(CPPFLAGS) $(TESTE_OBJ) -o $@

clean:
	rm -rf $(DGEMM_FIRST) *.o 
