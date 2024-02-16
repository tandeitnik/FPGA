import numpy as np

def bitString(decimalNumber,nBits, bitType = 'unsigned'):
    
    bit = bin(abs(decimalNumber))[2:]
    
    assert len(bit) <= nBits, "the given number cannot be written with the number of bits asked"
    
    if bitType == "signed":
        
        bit = '0'*(nBits-len(bit))+bit
        
        if np.sign(decimalNumber) == -1: #evaluate the 2's complement
            
            bit = NOT(bit)
            tmp = bit2decimal(bit) + 1
            bit = bitString(tmp,nBits)
            
    if len(bit) < nBits:
        
        bit = '0'*(nBits-len(bit))+bit
        
    return bit

def SLL(bitString,n):
    
    ans = bitString[n:] + '0'*min(n,len(bitString))
    
    return ans

def SRL(bitString,n):
    
    ans = '0'*min(n,len(bitString))+bitString[:len(bitString)-n]
    
    return ans

def leftRoll(bitString,n):
    
    if n > len(bitString):
        
        n = n-len(bitString)
    
    ans = bitString[n:] + bitString[:n]
    
    return ans

def rightRoll(bitString,n):
    
    if n > len(bitString):
        
        n = n-len(bitString)
    
    ans = bitString[len(bitString)-n:]+bitString[:len(bitString)-n]

    return ans

def XOR(bitString0,bitString1):
    
    ans = ''
    
    for i in range(len(bitString0)):
        
        ans = ans + str(int(bitString0[i])^int(bitString1[i]))
        
    return ans

def AND(bitString0,bitString1):
    
    ans = ''
    
    for i in range(len(bitString0)):
        
        ans = ans + str(int(bitString0[i]) and int(bitString1[i]))
        
    return ans

def OR(bitString0,bitString1):
    
    ans = ''
    
    for i in range(len(bitString0)):
        
        ans = ans + str(int(bitString0[i]) or int(bitString1[i]))
        
    return ans

def NOT(bitString):
    
    ans = ''
    
    for i in range(len(bitString)):
        
        ans = ans + str((int(bitString[i])+1)%2)
        
    return ans

def bit2decimal(bitStr, bitType = 'unsigned'):
    
    ans = 0
    
    if bitType == 'signed':
        
        if bitStr[0] == '1':
            
            tmp = bitSum(bitStr,bitString(1,len(bitStr)),subtract = True)
            tmp = NOT(tmp)
            
            for i in range(len(bitStr)):
                
                ans += int(tmp[-1-i])*2**i
                
            ans = ans*-1
            
        else:

            for i in range(len(bitStr)):
                
                ans += int(bitStr[-1-i])*2**i
                
    else:
        
        for i in range(len(bitStr)):
            
            ans += int(bitStr[-1-i])*2**i
        
    return ans

def bitSum(bitString0,bitString1,subtract = False):
    
    a = bit2decimal(bitString0)
    b = bit2decimal(bitString1)
    
    if subtract == True:
        ans = a-b
    else:
        ans = a+b
   
    ans = bitString(ans,max(np.floor(np.log2(ans)+1),len(bitString0),len(bitString1)))
    
    return ans


def tapList(n):
    
    taps = ['11', #2
            '110', #3
            '1100', #4
            '10100', #5
            '110000', #5
            '1100000', #6
            '10111000', #7
            '100010000', #8
            '1001000000', #9
            '10100000000', #10
            '111000001000', #11
            '1110010000000', #12
            '11100000000010', #13
            '110000000000000', #14
            '1101000000001000', #15
            '10010000000000000', #16
            '100000010000000000', #17
            '1110010000000000000', #18
            '10010000000000000000', #19
            '101000000000000000000', #20
            '1100000000000000000000', #21
            '10000100000000000000000', #22
            '111000010000000000000000'] #23
    
    assert len(taps)+1-n > 0 , 'There are no registered tap for the bit number'
    
    return taps[n-2]

def LFSR(seed):
    
    tap = tapList(len(seed))
    
    tmp = seed[-1]
    
    for i in range(1,len(seed)):
            
        if tap[i] == '1':
            
            tmp = XOR(tmp,seed[-1-i])
            
    ans = tmp + seed[:-1]
    
    return ans

N = 14
N_sum = 4
seed = '00000000000001'

uniformNumbers = [seed]
normalNumbers = []
normalNumbersDec = []

bitType = 'signed'

for i in range(1,2**N-1):
    
    uniformNumbers.append(LFSR(uniformNumbers[-1]))

for i in range(2**N-1):
    
    soma = 0
    
    for j in range(2**N_sum):
        
        soma += bit2decimal(uniformNumbers[(j + i) % 2**N-1], bitType)
    
    soma = int(np.fix(soma/(2**N_sum)))
    
    #soma = SRL( bitString(soma,N+N_sum,bitType) , N_sum )
    #normalNumbers.append(soma[N_sum:])
    normalNumbers.append(bitString(soma,N,bitType))
    
for i in range(2**N-1):
    
    normalNumbersDec.append(bit2decimal(normalNumbers[i], 'signed'))
    
import matplotlib.pyplot as plt

plt.hist(normalNumbersDec)