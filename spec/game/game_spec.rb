require 'game/game'
require 'game/history/history'
require 'game/components/pieces/pieces'
require 'game/components/board'
require_relative '../test_helper/h_board'
require_relative '../test_helper/h_piece'
require_relative '../test_helper/shortcut'

class Game; attr_accessor :board; end

describe Game, for: 'game_rp' do
  let(:game_rp) { Game.new '8/8/1prP4/2P5/8/8/8/8 w' }

  describe '#all_controlled_square' do
    let(:game_rp_cs_w) { [[2, 1], [2, 3], [1, 2], [1, 4]] }
    let(:game_rp_cs_b) { [[3, 0], [3, 2], [2, 3], [0, 2], [1, 2], [2, 1]] }

    it { expect(game_rp.all_controlled_square).to contain_exactly(*game_rp_cs_w) }
    it { expect(game_rp.all_controlled_square(true)).to contain_exactly(*game_rp_cs_b) }
  end

  describe '#all_normal_moves' do
    context 'with only_pos flag off' do
      let(:game_rp_nm_w) { sc_move_list('P23>13 P32>21') }
      let(:game_rp_nm_b) { sc_move_list('p21>31 p21>32 r22>32 r22>23 r22>02 r22>12') }

      it { expect(game_rp.all_normal_moves).to contain_exactly(*game_rp_nm_w) }
      it { expect(game_rp.all_normal_moves(true)).to contain_exactly(*game_rp_nm_b) }
    end

    context 'with only_pos flag on' do
      let(:game_rp_nm_p_w) { [[1, 3], [2, 1]] }
      let(:game_rp_nm_p_b) { [[3, 1], [3, 2], [2, 3], [0, 2], [1, 2]] }

      it 'return the normal possible move end squares positions for white' do
        expect(game_rp.all_normal_moves(only_pos: true)).to contain_exactly(*game_rp_nm_p_w)
      end
      it 'return the normal possible move end squares positions for black' do
        expect(game_rp.all_normal_moves(true, only_pos: true)).to contain_exactly(*game_rp_nm_p_b)
      end
    end
  end

  describe '#all_moves' do
    let(:normal_gw)    { Game.new 'NqB5/1ppp4/8/8/8/8/8/8 w' }
    let(:normal_gb)    { Game.new 'NqB5/1ppp4/8/8/8/8/8/8 b' }
    let(:castle_gw)    { Game.new 'r3k3/p7/2p5/8/8/4P3/7P/4K2R w' }
    let(:castle_gb)    { Game.new 'r3k3/p7/2p5/8/8/4P3/7P/4K2R b' }
    let(:en_pass_gw)   { Game.new 'k7/8/8/2pP4/5pP1/8/8/7N w' }
    let(:en_pass_gb)   { Game.new 'k7/8/8/2pP4/5pP1/8/8/7N b' }
    let(:promo_gw)     { Game.new 'n7/2P5/8/8/8/8/3p4/7K w' }
    let(:promo_gb)     { Game.new 'n7/2P5/8/8/8/8/3p4/7K b' }
    let(:all_gw)       { Game.new '4k2r/P6p/8/4pP2/2Pp4/8/P6p/R3K3 w' }
    let(:all_gb)       { Game.new '4k2r/P6p/8/4pP2/2Pp4/8/P6p/R3K3 b' }
    let(:normal_m_gw)  { sc_move_list('N00>12 N00>21 B02>11 B02>13') }
    let(:normal_m_gb)  { sc_move_list('q01>00 q01>02 q01>10 p11>21 p11>31 p12>22 p12>32 p13>23 p13>33') }
    let(:castle_m_gw)  { sc_move_list('P54>44 P67>57 P67>47 R77>76 R77>75 K74>75 K74>65 K74>64 K74>63 K74>73') + [Move.new(side: :short)] }
    let(:castle_m_gb)  { sc_move_list('r00>01 r00>02 r00>03 p10>20 p10>30 p22>32 k04>03 k04>13 k04>14 k04>15 k04>05') + [Move.new(side: :long)] }
    let(:en_pass_m_gw) { sc_move_list('N77>56 N77>65 P46>36 P33>23') + [Move.new([3, 3], [2, 2], sc_piece(:P33), en_pass_capture: [3, 2])] }
    let(:en_pass_m_gb) { sc_move_list('p45>55 p32>42 k00>01 k00>11 k00>10') + [Move.new([4, 5], [5, 6], sc_piece(:p45), en_pass_capture: [4, 6])] }
    let(:promo_m_gw)   { sc_move_list('K77>67 K77>76 K77>66') + [Move.new([1, 2], [0, 2], sc_piece(:P12), replacement: :unknown)] }
    let(:promo_m_gb)   { sc_move_list('n00>12 n00>21') + [Move.new([6, 3], [7, 3], sc_piece(:p63), replacement: :unknown)] }
    let(:all_m_gw) do
      sc_move_list('R70>71 R70>72 R70>73 K74>73 K74>63 K74>64 K74>65 K74>75 P42>32 P35>25 P60>50 P60>40') +
        [Move.new(side: :long), Move.new([1, 0], [0, 0], sc_piece(:P10), replacement: :unknown),
         Move.new([3, 5], [2, 4], sc_piece(:P35), en_pass_capture: [3, 4])]
    end
    let(:all_m_gb) do
      sc_move_list('r07>06 r07>05 k04>05 k04>15 k04>14 k04>13 k04>03 p17>27 p17>37 p34>44 p43>53') +
        [Move.new(side: :short), Move.new([6, 7], [7, 7], sc_piece(:p67), replacement: :unknown),
         Move.new([4, 3], [5, 2], sc_piece(:p43), en_pass_capture: [4, 2])]
    end

    it { expect(normal_gw.all_moves).to contain_exactly(*normal_m_gw) }
    it { expect(normal_gb.all_moves).to contain_exactly(*normal_m_gb) }

    it { expect(castle_gw.all_moves).to contain_exactly(*castle_m_gw) }
    it { expect(castle_gb.all_moves).to contain_exactly(*castle_m_gb) }
    specify do
      en_pass_gw.history.add_entry([1, 2], [3, 2], sc_piece(:p32))
      expect(en_pass_gw.all_moves).to contain_exactly(*en_pass_m_gw)
    end
    specify do
      en_pass_gb.history.add_entry([6, 6], [4, 6], sc_piece(:P46))
      expect(en_pass_gb.all_moves).to contain_exactly(*en_pass_m_gb)
    end
    it { expect(promo_gw.all_moves).to contain_exactly(*promo_m_gw) }
    it { expect(promo_gb.all_moves).to contain_exactly(*promo_m_gb) }
    specify do
      all_gw.history.add_entry([1, 4], [3, 4], sc_piece(:p34))
      expect(all_gw.all_moves).to contain_exactly(*all_m_gw)
    end
    specify do
      all_gb.history.add_entry([6, 2], [4, 2], sc_piece(:P42))
      expect(all_gb.all_moves).to contain_exactly(*all_m_gb)
    end
  end
end
