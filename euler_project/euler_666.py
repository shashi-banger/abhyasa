
import numpy as np
from collections import namedtuple
from collections import Counter
from itertools import product

ProbAndDelta = namedtuple('ProbAndDelta', "prob delta")
class Euler666:
    @staticmethod
    def q_prob(k, m):
        """ Gives a probability of each q(0-4) for all species
        
        :param k: Number of species
        :type k: int
        :param m: 
        :type m: int
        :returns: list(list()) l[i][q] is probability of mutation q for ithe species at each time step
        """
        mut_prob = []
        rn = [306]
        for n in range(1, k*m+m+1):
            rn.append((rn[-1]*rn[-1]) % 10007)

        for i in range(k):
            q = [rn[i*m+j] % 5 for j in range(m)]
            qf = Counter(q)
            mut_prob_i = [qf[v]/m for v in range(5)]
            mut_prob.append(mut_prob_i)
        
        return mut_prob

    def delta_on_mutation(self):
        """For each species i a mutation q can result in a delta change in population. This delta is precomputed
        in stored in dictionary

        :returns: {i:[np.array],} For each species i a list of size five whose each element is an np.array
                 of size k capturing the delta change in population for each mutation type q 
        """
        mut_delta = {}
        k = self.k
        for i in range(k):
            mut_delta[i] = []
            for q in range(5):
                t = np.zeros(k, dtype=np.int)
                if q == 0: 
                    # i dies
                    t[i] = -1
                elif q == 1:  
                    # i clones itself resulting in new type of i
                    t[i] = 1
                elif q == 2:
                    # i mutates into (2i)mod(k)
                    s = (2*i) % k
                    t[i] = -1
                    t[s] = 1
                elif q == 3:
                    # i splits into 2 of type (i*i+1)mod(k) replacing i
                    s = (i*i+1) % k
                    t[i] = -1
                    t[s] = 3
                elif q == 4:
                    # i spawns a new bacterium of type (i+1)mof(k) alongsize i who remains
                    s = (i+1) % k
                    t[s] = 1
                mut_delta[i].append(ProbAndDelta(prob=self.mut_prob[i][q], delta=t))

        return mut_delta

    def _init_max_death_prob(self):
        death_prob = [self.mut_prob[i][0] for i in range(self.k)]
        self.max_death_prob = max(death_prob)
        print(f"Max death prob {self.max_death_prob}")

    def _prune_states(self, s_t):
        filter_cond = lambda s: (self.max_death_prob ** s['population'].sum() > 0.000000001)
        s_t = filter(filter_cond, s_t)
        return s_t

    def __init__(self, k, m):
        self.k = k
        self.m = m
        self.mut_prob = self.q_prob(k, m)
        self.mut_delta = self.delta_on_mutation()
        self._init_max_death_prob()
        t = np.zeros(k, dtype=np.int)
        t[0] = 1
        self.s_t = [dict(prob=1, population=t)]
        self.prob_zero = 0

    def _check_and_add(self, new_s_t, prob, new_poulation):
        for s in new_s_t:
            #if (np.array(s['population']) - np.array(new_poulation)).sum() == 0:
            if tuple(s['population']) == tuple(new_poulation):
                s['prob'] += prob
                break
        else:
            new_s_t.append(dict(prob=prob, population=new_poulation))

    def evolve_step(self):
        new_s_t = []
        for s in self.s_t:
            live_pop_species = np.where(s['population'] > 0)[0]
            #print(s['population'])
            #print("live_pop_species  ", live_pop_species)
            delta_lists = [self.mut_delta[i] for i in live_pop_species]
            
            if len(delta_lists) == 1:
                iterable_prod_list = [[l] for l in delta_lists[0]]
            else:
                iterable_prod_list = product(*delta_lists)
            
            for prob_delta_combination in iterable_prod_list:
                new_poulation = s['population'].copy()
                prob = s['prob']
                
                #print("============", new_poulation, prob_delta_combination, type(prob_delta_combination))
                for prob_delta in prob_delta_combination:
                    prob *= prob_delta.prob
                    new_poulation += prob_delta.delta
                    #print(prob_delta.delta)
                #print("============", prob, new_poulation)
                if prob > 0:
                    self._check_and_add(new_s_t, prob, new_poulation)
                    #new_s_t.append(dict(prob=prob, population=new_poulation))

        n_s_prob = 0.0
        del_index = []
        #print((new_s_t))
        max_population = 0
        for i,s in enumerate(new_s_t):
            if s['population'].sum() > max_population:
                max_population = s['population'].sum()
            if s['population'].sum() == 0:
                self.prob_zero += s['prob']
                del_index.append(i)
            #print("++++++++++", s['population'].sum(), s['prob'])
            n_s_prob += s['prob']

        for d in del_index:
            new_s_t.pop(d)
          
        print("#########", max_population, len(new_s_t), n_s_prob, self.prob_zero)
        self.s_t = list(self._prune_states(new_s_t))
        #self.s_t = new_s_t
        
        return

    def evolve(self):
        for i in range(100):
            self.evolve_step()
                

if __name__ == "__main__":
    euler_666 = Euler666(4,3)
    euler_666.evolve()






