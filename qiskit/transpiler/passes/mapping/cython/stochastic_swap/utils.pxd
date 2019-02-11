# -*- coding: utf-8 -*-
#!python
#cython: language_level = 3, cdivision = True, nonecheck = False
#distutils: language = c++

# Copyright 2018, IBM.
#
# This source code is licensed under the Apache License, Version 2.0 found in
# the LICENSE.txt file in the root directory of this source tree.
from libcpp.vector cimport vector

# Numeric layout --------------------------------------------------------------
cdef class NLayout:
    cdef:
        unsigned int l2p_len
        unsigned int p2l_len
        unsigned int * logic_to_phys
        unsigned int * phys_to_logic

    # Methods
    cdef NLayout copy(self)
    cdef void swap(self, unsigned int idx1, unsigned int idx2)
    cpdef object to_layout(self, object dag)


cpdef NLayout nlayout_from_layout(object layout,
                                  object dag, 
                                  unsigned int physical_qubits)


# Edge collection -------------------------------------------------------------
cdef class EdgeCollection:
    cdef vector[unsigned int] _edges

    cpdef void add(self, unsigned int edge_start, unsigned int edge_end)


# Shifted RNG -----------------------------------------------------------------
cdef extern from "<random>" namespace "std":
    cdef cppclass mt19937:
        mt19937() # 32-bit Mersenne Twister 19937 generator
        mt19937(unsigned int seed)

    cdef cppclass normal_distribution[T]:
        normal_distribution()
        normal_distribution(T a, T b)
        T operator()(mt19937 rnd_gen)

cdef class SHIFTED_NORMAL_RNG:
    cdef:
        mt19937 rnd_gen
        normal_distribution[double] distro

    cpdef double rand(self)