# encoding: utf-8

RSpec.describe TTY::File::Differ, '#call' do
  it "diffs two files with single line content" do
    string_a = "aaa bbb ccc"
    string_b = "aaa xxx ccc"

    diff = TTY::File::Differ.new(string_a, string_b, :unified, 3).call

    expect(diff).to eq(strip_heredoc(<<-EOS
      @@ -1,2 +1,2 @@
      -aaa bbb ccc
      +aaa xxx ccc
    EOS
    ))
  end

  it "diffs two files with multi line content" do
    string_a = "aaa\nbbb\nccc\nddd\neee\nfff\nggg\nhhh\niii\njjj\nkkk\nlll\n"
    string_b = "aaa\nbbb\nzzz\nddd\neee\nfff\nggg\nhhh\niii\njjj\nwww\n"

    diff = TTY::File::Differ.new(string_a, string_b, :unified, 3).call

    expect(diff).to eq(strip_heredoc(<<-EOS
      @@ -1,6 +1,6 @@
       aaa
       bbb
      -ccc
      +zzz
       ddd
       eee
       fff
      @@ -8,6 +8,5 @@
       hhh
       iii
       jjj
      -kkk
      -lll
      +www
    EOS
    ))
  end

  it "handles differently encoded files" do
    string_a = "wikipedia".encode('us-ascii')
    string_b = "ウィキペディア".encode('UTF-8')

    diff = TTY::File::Differ.new(string_a, string_b, :unified, 3).call

    expect(diff).to eq(strip_heredoc(<<-EOS
      @@ -1,2 +1,2 @@
      -wikipedia
      +ウィキペディア
    EOS
    ))
  end
end
