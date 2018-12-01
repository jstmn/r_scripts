clc
seq = 'abac';

bins = get_bins_from_seq(seq);
dec = bi2de(bins);
sum_ = sum(dec);

function [bin] = get_bins_from_seq(seq)
    
    dna = 'abc';
    t = size(dna);
    len_dna = t(1,2);
    
    seq_char_arr = char(seq);
    t= size(seq_char_arr);
    len_seq_char_arr = t(1,2);
    
    bin = zeros(len_dna,len_seq_char_arr);
    
    for dna_index = 1:len_dna
        
        % dna_index is row of bin
        dna_char = dna(1,dna_index);
        seq_indexes = strfind(seq_char_arr,dna_char);
        
        t = size(seq_indexes);
        seq_indexes_vector_len = t(1,2);
        
        for seq_index = 1:seq_indexes_vector_len
            bin(dna_index, seq_indexes(1,seq_index)) = 1;
        end
    end
end